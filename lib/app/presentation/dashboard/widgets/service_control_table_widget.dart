import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_dashboard/app/core/constants/app_color.dart';
import 'package:service_dashboard/app/core/constants/app_text_style.dart';
import 'package:service_dashboard/app/core/enums/service_status.dart';
import 'package:service_dashboard/app/core/extensions/context/context_extension.dart';
import 'package:service_dashboard/app/core/extensions/string/string_extension.dart';
import 'package:service_dashboard/app/core/extensions/widget/widget_extension.dart';
import 'package:service_dashboard/app/data/models/service/service_model.dart';
import 'package:service_dashboard/app/presentation/dashboard/viewmodel/dashboard_view_model.dart';
import 'package:service_dashboard/app/presentation/services/detail/view/service_detail_view.dart';

class ServiceControlTableWidget extends StatelessWidget {
  ServiceControlTableWidget({super.key});
  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final DashboardViewModel controller = Get.find();
    ScrollController scrollController = ScrollController();
    Rx<String> sortOption = 'Service Name'.obs;
    Rx<bool> isAscOrder = true.obs;
    Rx<String> searchQuery = ''.obs;

    void _onSearchChanged(String query) {
      if (!_searchFocusNode.hasFocus) {
        _searchFocusNode.requestFocus();
      }
      searchQuery.value = query.toLowerCase();
    }

    return Obx(
      () => Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: context.border12Radius,
          border: Border.all(color: AppColor.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.failedServices.isNotEmpty) ...[
              Align(
                alignment: Alignment.topLeft,
                child: Text("Hatalı Servis/Cihaz Kontrol Tablosu", style: AppTextStyle.blackBold16)
                    .pAll(context.normalVal),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: context.heighVal),
                child: TextField(
                  focusNode: _searchFocusNode,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    labelText: "Servis veya Cihaz ismine göre ara",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColor.border),
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColor.greyDark),
                  ),
                ),
              ),
              Obx(() {
                List<ServiceModel> filteredServices = List.from(controller.failedServices);

                // Filtreleme
                if (searchQuery.value.isNotEmpty) {
                  filteredServices = filteredServices.where((service) {
                    final serviceName = service.name?.toLowerCase() ?? '';
                    final deviceName = service.devices?.any((device) =>
                            device.name?.toLowerCase().contains(searchQuery.value) ?? false) ??
                        false;
                    return serviceName.contains(searchQuery.value) || deviceName;
                  }).toList();
                }

                // Sıralama
                switch (sortOption.value) {
                  case 'Service Name':
                    filteredServices.sort((a, b) {
                      int comparison = (a.name ?? '').compareTo(b.name ?? '');
                      return isAscOrder.value ? comparison : -comparison;
                    });
                    break;
                  case 'Device Name':
                    filteredServices.sort((a, b) {
                      int comparison =
                          (a.devices?.first.name ?? '').compareTo(b.devices?.first.name ?? '');
                      return isAscOrder.value ? comparison : -comparison;
                    });
                    break;
                  case 'Last Checked':
                    filteredServices.sort((a, b) {
                      DateTime dateA =
                          a.lastChecked != null ? DateTime.parse(a.lastChecked!) : DateTime(0);
                      DateTime dateB =
                          b.lastChecked != null ? DateTime.parse(b.lastChecked!) : DateTime(0);

                      int comparison = dateA.compareTo(dateB);
                      return isAscOrder.value ? comparison : -comparison;
                    });
                    break;
                }

                return Scrollbar(
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  controller: scrollController,
                  child: DataTable(
                    sortColumnIndex:
                        ['Service Name', 'Device Name', 'Last Checked'].indexOf(sortOption.value),
                    sortAscending: isAscOrder.value,
                    columns: [
                      DataColumn(
                        label: Expanded(
                            child: Text(
                          'Servis Adı',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                        onSort: (index, ascending) {
                          sortOption.value = 'Service Name';
                          isAscOrder.value = ascending;
                        },
                      ),
                      DataColumn(
                        label: Expanded(
                            child: Text(
                          'Cihazlar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                        onSort: (index, ascending) {
                          sortOption.value = 'Device Name';
                          isAscOrder.value = ascending;
                        },
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Son Kontrol',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onSort: (index, ascending) {
                          sortOption.value = 'Last Checked';
                          isAscOrder.value = ascending;
                        },
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Durum',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ],
                    rows: filteredServices.map((service) {
                      final status = service.serviceCheckStatus.value;
                      final statusColor = {
                        ServiceCheckStatus.loading: AppColor.blueDark,
                        ServiceCheckStatus.blinking: AppColor.red,
                        ServiceCheckStatus.success: AppColor.greenDark,
                      }[status];
                      final statusWidget = {
                        ServiceCheckStatus.loading: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: statusColor,
                          ),
                        ),
                        ServiceCheckStatus.normal: GestureDetector(
                          onTap: () {
                            controller.checkService(service.id!);
                          },
                          child: Icon(Icons.refresh, color: statusColor),
                        ),
                        ServiceCheckStatus.success: Icon(Icons.check, color: statusColor),
                        ServiceCheckStatus.blinking: Icon(Icons.error, color: statusColor),
                      }[status];
                      final failedDevices = service.status == false
                          ? ["Servis Hatalı"]
                          : service.devices
                                  ?.where((device) => device.status == false)
                                  .map((device) => device.name ?? 'Bilinmiyor')
                                  .toList() ??
                              [];

                      return DataRow(
                        onLongPress: () => Get.to(() => ServiceDetailView(serviceId: service.id!)),
                        cells: [
                          DataCell(Text(
                            service.name ?? 'Bilinmiyor',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                          DataCell(
                            Text(
                              failedDevices.join(', '),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          DataCell(Text(service.lastChecked?.toFormattedDate(isHour: true) ?? '')),
                          DataCell(
                            Align(
                              alignment: Alignment.centerRight,
                              child: statusWidget!,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ).sized(width: Get.width),
                );
              }),
            ],
            if (controller.failedServices.isEmpty)
              Text("Hatalı Servis/Cihaz bulunamadı.", style: AppTextStyle.blackRegular14)
          ],
        ),
      ),
    );
  }
}

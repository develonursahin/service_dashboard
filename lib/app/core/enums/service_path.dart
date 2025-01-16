enum ServicePath { runningServices, failedServices, services, sendMail, checkService }

extension ServicePathExtension on ServicePath {
  String get subUrl {
    switch (this) {
      case ServicePath.runningServices:
        return 'services/running';
      case ServicePath.failedServices:
        return 'services/failed';
      case ServicePath.services:
        return 'services';
      case ServicePath.sendMail:
        return 'send-email';
      case ServicePath.checkService:
        return 'check-service';
    }
  }
}

enum BOOKING_STATUS { NONE, PENDING, ACCEPT, ONGOING, COMPLETE, CANCEL }

extension BookingStatusName on BOOKING_STATUS {
  String get name {
    switch (this) {
      case BOOKING_STATUS.NONE:
        return "None";
      case BOOKING_STATUS.PENDING:
        return "Pending";
      case BOOKING_STATUS.ACCEPT:
        return "Accept";
      case BOOKING_STATUS.ONGOING:
        return "OnGoing";
      case BOOKING_STATUS.COMPLETE:
        return "Complete";
      case BOOKING_STATUS.CANCEL:
        return "Cancel";
    }
  }
}

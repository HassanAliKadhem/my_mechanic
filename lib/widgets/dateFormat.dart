String FormatDate(DateTime dateTime) =>
    dateTime.toLocal().toString().split(" ")[0];

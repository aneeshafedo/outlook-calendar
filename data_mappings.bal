isolated function toCalendar(json payload, boolean isCollection) returns Calendar|CalendarCollection|error {
    if isCollection {
        CalendarCollection calendarCollection = check payload.cloneWithType(CalendarCollection);
        return calendarCollection;
    } else {
        Calendar calendar = check payload.cloneWithType(Calendar);
        return calendar;
    }
}

isolated function toCalendarCollection(json payload) {
    
}
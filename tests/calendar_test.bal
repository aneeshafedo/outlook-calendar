import ballerina/test;
import ballerina/log;

configurable string & readonly tokenEndPoint = ?;
configurable string & readonly appId = ?;
configurable string & readonly appSecret = ?;
configurable string & readonly refresh_token = ?;

Configuration bearerConfig = {
    clientConfig: {
        refreshUrl : tokenEndPoint,
        refreshToken : refresh_token,
        clientId : appId,
        clientSecret : appSecret,
        scopes: ["https://graph.microsoft.com/Calendars.ReadWrite"]
    }
};

Client calendarClient = check new(bearerConfig);
string calendarId = "";

@test:Config {}
function testListCalendars() {
    log:printInfo("client->listCalendars()");
    CalendarCollection|error myCalendars = calendarClient->listCalendars();
    if (myCalendars is CalendarCollection) {
        log:printInfo("Number of Calendars : " + myCalendars.value.length().toString());
    } else {
        test:assertFail(msg = myCalendars.message());
    }
}

@test:Config {}
function testcreateCalendar() {
    log:printInfo("client->createCalendar()");
    Calendar|error myCalendar = calendarClient->createCalendar("My Test Calendar 2020");
    if (myCalendar is Calendar) {
        log:printInfo("Calendars ID : " + <string>myCalendar?.id);
        calendarId = <string>myCalendar?.id;
    } else {
        test:assertFail(msg = myCalendar.message());
    }
}

@test:Config {dependsOn: [testcreateCalendar]}
function testgetCalendar() {
    log:printInfo("client->getCalendar()");
    Calendar|error myCalendars = calendarClient->getCalendar(calendarId);
    if (myCalendars is Calendar) {
        log:printInfo("Calendar Name : " + myCalendars.name);
    } else {
        test:assertFail(msg = myCalendars.message());
    }
}

@test:Config {dependsOn: [testgetCalendar]}
function testupdateCalendar() {
    log:printInfo("client->updateCalendar()");
    Calendar newCalendar = {name : "My Test Calendar 2021"};
    Calendar|error updatedCalendar = calendarClient->updateCalendar(newCalendar, calendarId = calendarId);
    if (updatedCalendar is Calendar) {
        log:printInfo("Calendar Name : " + updatedCalendar.name);
    } else {
        test:assertFail(msg = updatedCalendar.message());
    }
}

@test:Config {dependsOn: [testupdateCalendar]}
function testdeleteCalendar() {
    log:printInfo("client->deleteCalendar()");
    error? deletedCalendar = calendarClient->deleteCalendar(calendarId);
    if (deletedCalendar is error) {
        test:assertFail(msg = deletedCalendar.message());
    } else {
        log:printInfo("Calendar Deleted Successfully");
    }
}

@test:Config {}
function testlistCalendarView() {
    log:printInfo("client->listCalendarView()");
    string startDateTime = "2021-03-01T19:00:00-08:00";
    string endDateTime = "2021-04-14T19:00:00-08:00";
    error|EventCollection eventList = calendarClient->listCalendarView(startDateTime,endDateTime,calendarId);
    if (eventList is EventCollection) {
        log:printInfo("Number of Calendars : " + eventList.value.length().toString());
    } else {
        test:assertFail(msg = eventList.message());
    }
}
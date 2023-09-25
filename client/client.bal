import ballerina/http;
import ballerina/io;


public type LECTURER record {
    string staff_number?;
    string staff_name?;
    string title?;
    string course_id?;
    string office_id?;
};

public type COURSE readonly & record {
    string course_id;
    string course_name;
    string [] NQF_level;
};

type OFFICE readonly & record {
    int office_id;
    int office_number;
};
public function main()returns error? {
    http:Client UserClient=check new ("localhost:8080/");

    //user input
    io:println("Welcome to the management system");
    io:println("KeyWords:");
    io:println("add       -To Add a Lecturer");
    io:println("showall   -To show all Lecturers:");
    io:println("update    -To update a Lecturer:");
    io:println("delete    -To Delete a Lecturer:");
    io:println("retrievebyStaffNo  -To retrieve lecturer by Staff Number   :");
    io:println("retrievebyCourse   -To retrieve lecturer by Course id:");
    io:println("retrievebyOffice   -To retrieve lecturer by Office Id :");
    string keyword=io:readln("Enter a Keyword: ");

    if keyword=="add"{
        LECTURER lecturer={staff_number: "", staff_name: "", course_id: "",office_id: "", title: ""};
        lecturer.staff_number=io:readln("enter staff_number: ");
        lecturer.staff_name=io:readln("enter staff_name: ");
        lecturer.office_id=io:readln("enter office_id: ");
        lecturer.course_id=io:readln("enter course_id: ");
        lecturer.title=io:readln("enter title e,g 'Mr or Ms': ");
        check CreateStaff(UserClient,lecturer);
    } else if keyword == "showall"{
        check getAllStaff(UserClient);
    } else if keyword == "update"{
        LECTURER lecturer={staff_number: "", staff_name: "", course_id: "", office_id: "", title: ""};
        lecturer.staff_number=io:readln("enter staff_number: ");
        lecturer.staff_name=io:readln("enter staff_name: ");
        lecturer.office_id=io:readln("enter office_number: ");
        lecturer.course_id=io:readln("enter CourseName: ");
        lecturer.title=io:readln("enter title e,g 'Mr'or 'Ms'");
        check UpdateStaff(UserClient,lecturer);
    } else if keyword == "delete"{
        string staff_number=io:readln("Which lecturer do you wish to delete: ");
        check DeleteStaff(UserClient,staff_number);
    } else if keyword == "retrievebyLecturerNo"{
        string staff_number=io:readln("Enter a lecturer Number: ");
        check getStaffByStaffNo(UserClient,staff_number);
    } else if keyword == "retrievebyCourse"{
        string course_id=io:readln("Which Course: ");
        check getByCourseName(UserClient,course_id);
    } else if keyword == "retrievebyOffice"{
        string office_id=io:readln("Office Number: ");
        check getByOfficeNo(UserClient,office_id);
    } else {
    io:println("That is not a Keyword:");
    string back=io:readln("To go back just type back: ");
    if(back=="back"){
    error? MainMenu=main();
        if MainMenu is error{
            io:println("Yeah... Thats not a command");
        }
    }
    }
};
//Get all Lecturers
public function getAllStaff(http:Client http) returns error?{
    if (http is http:Client){
        LECTURER[] lecturer=check http->/getAllLecturers;
        foreach LECTURER item in lecturer{
            io:println("Lecturer Number:",item.staff_number,", Lecturer Name:",item.staff_name,", Office Id:",item.office_id,", Course ID:",item.course_id);
        }
    }
    string back=io:readln("To go back just type back: ");
    if(back=="back"){
    error? MainMenu=main();
        if MainMenu is error{
            io:println("Yeah... Thats not a command");
        }
    }
}
public function getStaffByStaffNo(http:Client http, string staff_number)returns error?{
    if(http is http:Client){
        LECTURER lecturer=check http->/getLecturer(staff_number=staff_number);
        io:println("Lecturer Number: ",lecturer.staff_number," Lecturer Name: ",lecturer.staff_name," Office Id: ",lecturer.office_id," Course Id: ",lecturer.course_id);
    }
}
public function getByCourseName(http:Client http,string course_id) returns error?{
    if (http is http:Client){
        LECTURER lecturer=check http->/getByCourseId(course_id=course_id);
        io:println("Lecturer Number: ",lecturer.staff_number," Lecturer Name: ",lecturer.staff_name," Office Id: ",lecturer.office_id," Course Id: ",lecturer.course_id);
    }
}
public function getByOfficeNo(http:Client http, string office_id) returns error?{
    if(http is http:Client){
        LECTURER lecturer=check http->/getByOfficeId(office_id=office_id);
        io:println("Lecturer Number: ",lecturer.staff_number," Lecturer Name: ",lecturer.staff_name," Office Pd: ",lecturer.office_id," Course Id: ",lecturer.course_id);
    }
}
//To add a lecturer
function CreateStaff(http:Client http, LECTURER lecturer) returns error?{
    if(http is http:Client){
        string message=check http->/addLecturer.post(lecturer);
        io:print(message);
    }
}
public function AddStaff()returns string{
    string lecturerName=io:readln("Enter a Lecturer Name: ");
    return lecturerName;
}
# Description.
#
# + http - parameter description  
# + update_lecturer - parameter description
# + return - return value description
public function UpdateStaff(http:Client http,LECTURER update_lecturer)returns error?{
     LECTURER update =check http->/updatelecturer.put(update_lecturer);
    io:println(update_lecturer);
}
public function DeleteStaff(http:Client http,string|string[] staff_number) returns error?{
    if(http is http:Client){
        string message=check http->/deletelecturer.get({staff_number});
        io:println(message);
    }
}
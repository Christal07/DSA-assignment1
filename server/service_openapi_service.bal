import ballerina/http;
import ballerina/io;

listener http:Listener ep0 = new (8080, config = {host: "localhost"});

service / on ep0 {
    //Resource function to add a lecturer
    resource function post addLecturer(@http:Payload LECTURER newLecturer) returns string {
           io:println(newLecturer);
       error? createNewLecturer = lecturerTable.add(newLecturer);

       if (createNewLecturer is error){
        return "Error adding the lecturer" + createNewLecturer.message();
       }else{

       // return string `${newLecturer.staff_number} saved successfully`;
       return newLecturer.staff_number + "saved successfully";
       }
    }
    
    //Resource function to get all lecturers
    resource function get getAllLecturers() returns LECTURER[] {
      return lecturerTable.toArray();
    }

    //Resource functions to get lecturers within the same course
    resource function get getAllLecturers/[string course_id]() returns LECTURER|string{
        foreach LECTURER lecturer in lecturerTable{
            if(lecturer.course_id===course_id){
                return lecturer;
            }
        }
        return course_id + "Does not exist";
    }

//get staff members by office_id
    resource function get getByOfficeId(string office_id) returns LECTURER|string{
        foreach LECTURER lecturer in lecturerTable{
            if(lecturer.office_id===office_id){
                return lecturer;
            }
        }
        return office_id + "Does not exist";
    }

   //Resource function to get a lecturer by their staff number
    resource function get getLecturer/[string staff_number]() returns string|error {
        LECTURER? getLecturer = lecturerTable.get(staff_number);

        if (getLecturer == null ){
            return error ("This lecturer does not exist");
        }else{
            return getLecturer.staff_number + "Here is the lecturer" ;
        }
    }
   
   //Resource function to update an existing lecturer's info
    resource function put updateLecturer(@http:Payload LECTURER lecturer) returns string {
        io:println(lecturer);
        error? err=lecturerTable.put(lecturer);
        if(err is error){
            return string `Error,${err.message()}`;
        }
        return string `Error,${lecturer.staff_number} saved successfully`;
    }
    
    //Resource function to delete a lecturer by their staff number
    resource function delete deleteLecturer/[string staff_number]() returns string {
           lecturerTable=<table<LECTURER>key(staff_number)>lecturerTable.filter((lecturer)=>lecturer.staff_number != staff_number);
        table<LECTURER> lecturerTable2=table[];
        if (lecturerTable.length()===lecturerTable2.length()){
                    return staff_number + " not found.";
        }
        return staff_number + " successfuly deleted" ;

     }
}

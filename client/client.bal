 import ballerina/io;


// Creates a gRPC client to interact with the remote server.
MgmentSystemClient ep = check new ("http://localhost:9090");
 

public function main() returns error? {

io:println(MainMenu());
    
    
}



function MainMenu() returns string|error {
    io:println("Enter the System");
   
   
    string input =io:readln("Press 1_");

    if (input == "1") {
        return Login();
    }

    else {
        return Register();
    }


    
}

function Register() returns string|error {

    string UserId = io:readln("Input ID...");
    string Name = io:readln("Input User Name...");
    string profile = io:readln("Input Profile type...");

    User theUser = {
        userId: UserId,
        name: Name,
        accountType: profile
    };

    string addedUser = check ep->create_user(theUser);

    io:println(addedUser);

    string input = io:readln("\n\nGo back");

    if input == "1" {
        return Login();
    }

    return addedUser;

}

function Login() returns string|error {


    io:println("<<Enter as: >>");

    io:println("\n\n1)Student");
    io:println("2)Librarian");




    string input = io:readln("\n\nEnter user type: ");

   // User user = check ep->getUser(id);

    if (input == "1") {
        return studentMenu();
    }

    else {
        return Menu();
    }

}

function studentMenu() returns string|error {

    io:println("1) Get All Books(available)");
    io:println("2) Find Book using ISBN");
    io:println("3) Borrow a Book");

    string input = io:readln("choose a Number__");

    if (input == "1") {

        string|error result = availableBook();

        return result;

    }

    if (input == "2") {

        string|error result = LocateBookByISBN();

        return result;

    }

    if (input == "3") {

        string|error result = borrowedBook();

        return result;

    }

    string inputx = io:readln("\n\nGo back...");

    if input == "1" {
        return Login();
    }

    return "Thank you for using the library";


}

function Menu() returns string|error {
   
   io:println("1) Create a User");
   io:println("2) Add a Book");
   io:println("3) Update a Book");
   io:println("4) Remove/delete a Book");
   io:println("5) Get All Books(available)");
   io:println("6) Find Book by ISBN");
   io:println("7) Borrow a Book");

  string input = io:readln("choose a Number__");

  if(input=="1") {

   string|error user = createUser();

   return user;

  }

 if(input=="2") {

   string|error result = addBook();

   return result;
  }

 if(input=="3") {

   string|error result = updateBook();

   return "updated";

  }

  if(input=="4") {

   string|error result = removeBook();

   return result;

  }

    if(input == "5")    {

        string|error result = availableBook();

        return result;

    }

    if (input == "6") {

        string|error result = LocateBookByISBN();

        return result;

    }

    if (input == "7") {

        string|error result = borrowedBook();

        return result;

    }




    return "Invalid selection try again";

}

function addBook() returns string|error{

        string Title = io:readln("Enter Book Title...");
        string Author = io:readln("Enter Authors Name...");
        string Location = io:readln("Enter the Book's location in the library...");
        string ISBN = io:readln("Enter the Book's isbn number...");
        string Status = io:readln("Is the book available?...");

         Book book = {
                  title: Title,
                  author_1: Author,
                  author_2: "",
                  location: Location,
                  isbn: ISBN,
                  status: Status
    
                };

        string addedBook = check ep->add_book(book);

    string input = io:readln("\n\nEnter (1) to return to Exit");

    if input == "1" {
        return Menu();
    }
        return addedBook;

}





function createUser() returns string|error {

    string UserId = io:readln("Input ID...");
    string Name = io:readln("Input User Name...");
    string profile = io:readln("Input Profile type...");

User theUser = {
                  userId :  UserId,
                  name : Name,
                  accountType: profile
    };

        string addedUser = check ep->create_user(theUser);
    

        io:println(addedUser);

        string input=io:readln("\n\nEnter (1) to return to Exit");

        if input == "1" {
          return Menu();
        }

        return addedUser;

    }




function updateBook() returns string|error{

        string Title = io:readln("Enter Book Title...");
        string Author = io:readln("Enter Authors Name...");
        string Location = io:readln("Enter the Book's location in the library...");
        string ISBN = io:readln("Enter the Book's isbn number...");
        string Status = io:readln("Is the book available?...");

         Book book = {
                  title: Title,
                  author_1: Author,
                  author_2: "",
                  location: Location,
                  isbn: ISBN,
                  status: Status
    
                };

        Book updatedBook = check ep->update_book(book);

        string theUpdate = updatedBook.toString();


        string input = io:readln("\n\nEnter (1) to return to Exit");

    if input == "1" {
        return Menu();
    }
    

        return theUpdate;

}

function removeBook() returns string|error {

    string isbn = io:readln("Enter The Books ISBN:");

string removed= check ep->remove_book(isbn);

io:print(removed);

    string input = io:readln("\n\nEnter (1) to return to Exit");

    if input == "1" {
        return Login();
    }
    

    return removed;


}

function availableBook() returns string|error {

        
string books = check ep->available_books();

    io:println(books);

    string input = io:readln("\n\nEnter (1) to return to Exit");

    if input == "1" {
        return Login();
    }
    
    return books;


}

function LocateBookByISBN() returns string|error {

string  isbn = io:readln("Enter The Books ISBN:");

string theBook = check ep->locate_book(isbn);

io:println( theBook);

    string input = io:readln("\n\nEnter (1) to return to Exit");

    if input == "1" {
        return Login();
    }

return theBook;

}


function borrowedBook()returns string|error {


  io:println("Borrow a Book Menu");


string UserId  = io:readln("Enter User ID...");
string ISBN = io:readln("Enter Books ISBN...");

    Borrowed_books borrowed = {
        userId: UserId,
        isbn: ISBN
    };

    Book book = {
        title: "",
        author_1: "",
        author_2: "",
        location: "",
        isbn: ISBN,
        status: "Borrowed"
    };

    // Executes a simple remote call.
    
    string|error borrowedBook = check ep->borrow_book(borrowed);
    Book|error updateStatus = check ep->update_book(book);


    io:println(borrowedBook);

    string input = io:readln("\n\nEnter (1) to return to Exit");

    if input == "1" {
        return Login();
    }
    
    return borrowedBook;


}

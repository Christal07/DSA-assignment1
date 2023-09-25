import ballerina/grpc;
 

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: MGMENTSYSTEM_DESC}


service "MgmentSystem" on ep {


     private table<Book> key(isbn) books;
     private table<User> key(userId) users;
     private table<Borrowed_books> key(isbn) borrowedBooks;

      
     function  init() {
        
        self.books = table[];
        self.users = table[];
        self.borrowedBooks = table [];

       
     }




    remote function add_book(Book book) returns string|error {
       
        self.books.add(book);

        return "You added "+book.isbn+" ";
    }

    remote function create_user(User user) returns string|error {


         self.users.add(user);
        return "New user added "+user.name;
    }

    remote function get_user(string userId) returns User?|error {
        
        User? theUser = self.users[userId];

        return theUser;

        
    }

    remote function update_book(Book partBook) returns Book?|string {
        
         Book? theBook = self.books[partBook.isbn];
        
        if theBook == (){
            return "Error book with isbn number "+partBook.isbn+" not found";
            
        }else{
            string? title = partBook?.title;
            if title != (){
                theBook.title = title;
            }

            string? author = partBook?.author_1;
            if author != () {
                theBook.author_1 = author;
            }

            string? author2 = partBook?.author_2;
            if author != () {
                theBook.author_2 = author;
            }

            string? location = partBook?.location;
            if location != () {
                theBook.location = location;
            }

            string? status = partBook?.status;
            if status != () {
                theBook.status = status;
            }
        }
        
        return theBook;

    }
remote function remove_book(string isbn) returns Book?|string {

         Book? theBook = self.books[isbn];
         
       Book? newBooks=self.books.remove(isbn);

        if newBooks == () {
            return  "No book removed";
        }else {
            return newBooks.toString();
        }
         

}

    remote function available_books() returns string|error {

        string books =self.books.toString();

        if books == "" {
            return "No books available";
        }
        else {
            return books;
        }
       

}

    remote function locate_book(string isbn) returns string {
        
        Book? theBook = self.books[isbn];
       
        if theBook == () {
            return  "There's no book with this isbn code.";

        } else {
            return "The book is located at "+theBook.location;
        }


   
    }
    remote function borrow_book(Borrowed_books book) returns string|error {

        Book? theBook = self.books[book.isbn];

        self.borrowedBooks.add({userId: book.userId, isbn: book.isbn});
        


        return "Book was borrowed to user "+book.userId;
    }
}


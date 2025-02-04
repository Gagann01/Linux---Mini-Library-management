#!/bin/bash

# Define color codes for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}----------------------------------------------------${NC}"
echo -e "${YELLOW}Welcome to the Mini Library Management System!${NC}"
echo -e "${CYAN}----------------------------------------------------${NC}"

# Prompt user for the library name
echo "Enter the name of your library:"
read lib_name

# Check if the library already exists
if [ -d "$lib_name" ]; then
    echo -e "${YELLOW}Library '$lib_name' already exists. Loading...${NC}"
else
    # Create library structure
    mkdir -p "$lib_name/books" "$lib_name/students"
    touch "$lib_name/books/books_list.txt" "$lib_name/students/students.txt" "$lib_name/borrowed_books.txt" "$lib_name/log.txt"
    echo -e "${GREEN}Library '$lib_name' has been created successfully.${NC}"
fi

# Function to log actions
log_action() {
    echo "$(date): $1" >> "$lib_name/log.txt"
}

# Function to add a book
add_book() {
    echo "Enter book name:"
    read book_name
    echo "$book_name" >> "$lib_name/books/books_list.txt"
    echo -e "${GREEN}Book '$book_name' added to the library.${NC}"
    log_action "Added book: $book_name"
}

# Function to remove a book
remove_book() {
    echo "Enter book name to remove:"
    read book_name
    if grep -Fxq "$book_name" "$lib_name/books/books_list.txt"; then
        grep -Fxv "$book_name" "$lib_name/books/books_list.txt" > temp.txt && mv temp.txt "$lib_name/books/books_list.txt"
        echo -e "${RED}Book '$book_name' removed from the library.${NC}"
        log_action "Removed book: $book_name"
    else
        echo -e "${RED}Book not found in the library.${NC}"
    fi
}

# Function to list all books
list_books() {
    echo -e "${CYAN}Books in Library:${NC}"
    cat "$lib_name/books/books_list.txt"
}

# Function to register a student
register_student() {
    echo "Enter student name:"
    read student_name
    echo "$student_name" >> "$lib_name/students/students.txt"
    echo -e "${GREEN}Student '$student_name' registered successfully.${NC}"
    log_action "Registered student: $student_name"
}

# Function to view registered students
list_students() {
    echo -e "${CYAN}Registered Students:${NC}"
    cat "$lib_name/students/students.txt"
}

# Function to borrow a book
borrow_book() {
    echo "Enter student name:"
    read student_name
    echo "Enter book name:"
    read book_name
    
    if grep -Fxq "$book_name" "$lib_name/books/books_list.txt"; then
        echo "$student_name borrowed '$book_name'" >> "$lib_name/borrowed_books.txt"
        echo -e "${GREEN}Book '$book_name' borrowed by '$student_name'.${NC}"
        log_action "$student_name borrowed $book_name"
    else
        echo -e "${RED}Book not available in the library.${NC}"
    fi
}

# Function to view borrowed books
view_borrowed_books() {
    echo -e "${CYAN}Borrowed Books:${NC}"
    cat "$lib_name/borrowed_books.txt"
}

# Main menu loop
while true; do
    echo -e "${CYAN}----------------------------------------------------${NC}"
    echo -e "${YELLOW}Mini Library Management System${NC}"
    echo -e "${CYAN}----------------------------------------------------${NC}"
    echo -e "1. Add a Book"
    echo -e "2. Remove a Book"
    echo -e "3. List All Books"
    echo -e "4. Register a Student"
    echo -e "5. View Registered Students"
    echo -e "6. Borrow a Book"
    echo -e "7. View Borrowed Books"
    echo -e "8. Exit"
    echo -e "${CYAN}----------------------------------------------------${NC}"
    
    read -p "Enter your choice: " choice
    
    case $choice in
        1) add_book ;;
        2) remove_book ;;
        3) list_books ;;
        4) register_student ;;
        5) list_students ;;
        6) borrow_book ;;
        7) view_borrowed_books ;;
        8) 
            echo -e "${YELLOW}Exiting the Library Management System. Goodbye!${NC}"
            exit 0
            ;;
        *) echo -e "${RED}Invalid choice! Please enter a valid option.${NC}" ;;
    esac
done


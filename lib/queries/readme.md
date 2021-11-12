
# Equality
- < less than
- <= less than or equal to
- == equal to
- \> greater than
- \>= greater than or equal to
- != not equal to

### Rules
- In a compound query, range (<, <=, >, >=) and not equals (!=, not-in) comparisons must all filter on the same field.
- You can't order your query by a field included in an equality (==) or in clause.

# Search Inside Array
### array-contains
The array in your document contains the value passed
    

### array-contains-any
The array in your document contains any of the values passed
    
# Search Via Array

### in
You pass an array of values, and the value is inside the array

### not-in
You pass an array of values, and the value is not inside the array
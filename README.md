# Restaurants Review Demo App

  Recruitment task for iOS job application.

## Requirements
- User must be able to create an account and log in. (this means that more users can use the app from the same phone).
- Implement 2 roles with different permission levels
  - Regular User: Can rate and leave a comment for a restaurant
  - Admin: Can add/edit/delete, restaurants, users and reviews
- Reviews should have:
  - A 5 star based rate
  - Date of the visit
  - Comment
- When a Regular User logs in he will see a Restaurant List ordered by Rate Average
- When a restaurant is selected, a detailed view should be presented showing:
  - The overall average rating
  - The highest rated review
  - The lowest rated review
  - Latest review showing with rate and comment
- Functional UI design is needed. You are not required to create a unique design, however, do follow best practices to make the project as functional as possible.

## Current imaplementation
### Currently the app is only partially implemented. The basic UI flow is covered. Requirements marked with green are completed.

- User must be able to create an account and log in. (this means that more users can use the app from the same phone). $\color{green}{\textsf{(partly done)}}$
- Implement 2 roles with different permission levels
  - $\color{green}{\textsf{Regular User: Can rate and leave a comment for a restaurant}}$
  - Admin: Can add/edit/delete, restaurants, users and reviews

- $\color{green}{\textsf{Reviews should have:}}$
  - $\color{green}{\textsf{  5 star based rate}}$
  - $\color{green}{\textsf{Date of the visit}}$
  - $\color{green}{\textsf{Comment}}$
- $\color{green}{\textsf{When a Regular User logs in he will see a Restaurant List ordered by Rate Average. }}$
- $\color{green}{\textsf{When a restaurant is choosen a detailed view should be presented }}$
- 
  - $\color{green}{\textsf{The overall average rating}}$
  - $\color{green}{\textsf{The highest rated review}}$
  - $\color{green}{\textsf{The lowest rated review}}$
  - $\color{green}{\textsf{Latest review showing with rate and comment}}$
  - $\color{green}{\textsf{Functional UI design is needed. You are not required to create a unique design, however, do follow best practices to make the project as functional as possible.}}$

<br>  </br>
## Demonstrated so far:
- UI/UX design and principles
- UIKit with storyboards
- Custom reusable UI elements
- MVC
- Manually writen code (not AI generated)
- Delegation pattern
- Good code practices

## To be implemented
- UI
  - Additional screens for RegisterUser, ForgotPassword, ReviewDetail/Update
  - Enhance UI to add ability to logout, edit/delete reviews, restaurants and users
- Local persistence (CoreData) with CRUD operations
- Session/Identity manager
- Coordinator for navigation

## Screens current state
## Testing info - tap on Forgot Password an it will automatically fillin a testing user password and username
<br>  </br>
- Login flow
<img src="https://github.com/user-attachments/assets/94fd8481-4c43-4772-9260-7ae9cb67fbcf" width="300">
<img src="https://github.com/user-attachments/assets/e63ce7e2-0419-4ac7-a436-4927b0c5fd6c" width="300">
<img src="https://github.com/user-attachments/assets/26beb061-e133-4518-a9b8-3177f68a6182" width="300"> 

<br>  </br>
- Restasurants Listing
<img src="https://github.com/user-attachments/assets/7b73212c-c067-4a20-8840-fd700383369d" width="300">
<img src="https://github.com/user-attachments/assets/399dc3ec-49a2-47a2-9768-08465c5ec351" width="300">

<br>  </br>
- Restasurant Detail
<img src="https://github.com/user-attachments/assets/55111d67-264e-4761-825c-9bfe5ae9418b" width="300">
<img src="https://github.com/user-attachments/assets/eb5b9c69-aa6d-487f-90a7-054919db27e7" width="300">

<br>  </br>
- Rate & Review
<img src="https://github.com/user-attachments/assets/f26ca5b1-9e80-4892-9497-01a69413c57c" width="300">
<img src="https://github.com/user-attachments/assets/07f1418c-1764-48d5-9e4d-72db2d4793f6" width="300"> 
<img src="https://github.com/user-attachments/assets/50348ad3-5976-453e-9569-cb90f03d2b7a" width="300">


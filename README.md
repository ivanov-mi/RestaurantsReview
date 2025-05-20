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
### The task implementation has been extended to improve UI/UX, introduce additional functionality, and establish a more robust and scalable app architecture.

<br>  </br>
## Technologies and methodologies applied:
- UI/UX design and principles
- UIKit with storyboards
- Custom reusable UI elements
- MVC
- Manually writen code (not AI generated)
- Delegation pattern
- Singleton pattern
- Coordinator pattern
- Keychain integration
- Core Data integration
- Session/Identity manager
- Good code practices

## Areas of improvement 
- Codebase
  - From core perspective
  - Refactor
  - Split the storyboard
  - Manage errors
  - Improre CoreData local persistance
  - Implement notifications
  - Add build configurations
  - Add depedancy injection
  - Add Unit testing
  - 
- UI/UX
  - Fix some UI bugs
  - Enhance visual consistency across screens
  - Rework some of the UX flows
  - Improve error screens and messages
  - Add Launch screen
  - Add loading indicators and user feedback elements 

- Functionality
  - Add filtering in admin panel
  - Add sorting options to listing screens
  - Add swipe down to refresh
  - Improve Admin panel design 
  - Improve Add/Edit restaurant 
  - Implement Forgot Password functionality 
  - Enhance user profile functionality
  - Implement Google NearMeAPI


## Screens
<br>  </br>
- Login flow
  ## For demo purposes is integrated "Populate testing data" / "Clear test data" functionality 
<img src="https://github.com/user-attachments/assets/850db478-094f-4915-b9c0-01f3cedbcc04" width="300">
<img src="https://github.com/user-attachments/assets/73bfb5fa-076d-4c86-b115-007b0c98ea6b" width="300">
<img src="https://github.com/user-attachments/assets/8b2ac3ac-100a-4e65-8f8e-679853547cab" width="300"> 
<img src="https://github.com/user-attachments/assets/a0c25157-20dd-4fed-997b-44d2fe659554" width="300">
<img src="https://github.com/user-attachments/assets/b56cc0d5-ccda-4a2b-9163-6656a3c53577" width="300">
<img src="https://github.com/user-attachments/assets/e22511c1-6559-4c81-a0eb-1c8ef867f7dc" width="300"> 


<br>  </br>
- Restasurants Listing
  - Regular user
<img src="https://github.com/user-attachments/assets/3a33fe94-5833-4990-8eea-6cdfc4f4d90c" width="300">
<br>
  - Admin
<br>
<img src="https://github.com/user-attachments/assets/0735c3d5-7446-4950-813c-f7582404ef25" width="300">
<img src="https://github.com/user-attachments/assets/3130ed35-35b7-4710-a3f0-860ae823b5d5" width="300">
<img src="https://github.com/user-attachments/assets/bfd1ce7f-4941-462a-b416-824c18d9cfa5" width="300">
<img src="ttps://github.com/user-attachments/assets/83c60e6a-3081-44e1-adcd-c1d191828bc0" width="300">



<br>  </br>
- Restasurant Details
  - Regular user
<img src="https://github.com/user-attachments/assets/d5f80758-a25b-4e21-8a59-d0af03dd073a" width="300">
<br>
  - Admin<br>
<img src="https://github.com/user-attachments/assets/1622cbb1-c042-49db-9b33-05a3377f60c0" width="300">
<br>  </br>



- Add/Update restrauntan (Admin only)
<img src="https://github.com/user-attachments/assets/f70f559e-e643-40ae-bd95-f0f6fe583832" width="300">
<img src="https://github.com/user-attachments/assets/ae8ee993-48b9-415f-aabc-7a5a667e1e4d" width="300">
<img src="https://github.com/user-attachments/assets/088ca07f-17cf-4df8-9565-7e8f446421e7" width="300">
<br>  </br>



- Create review
<img src="https://github.com/user-attachments/assets/504df103-9862-4cb8-8c44-b5729d2a8189" width="300">
<img src="https://github.com/user-attachments/assets/1ad8065b-1960-4959-b474-2369968ad78d" width="300">
<img src="https://github.com/user-attachments/assets/79228639-2986-4397-b3a2-4b55e4db187a" width="300">
<br>  </br>


- Review Details
  - Regulard user (if not author)
<img src="https://github.com/user-attachments/assets/0885439c-150c-4764-80b6-0e524d77daad" width="300">
<br>
  - Admin or Author<br>
<br>
<img src="https://github.com/user-attachments/assets/d507bc89-296f-44fc-aaeb-eb138605c6b6" width="300">
<img src="https://github.com/user-attachments/assets/6efa3ef6-5995-4fd1-af0e-6478c3c2eaab" width="300">
<br>  </br>


- User Profile
## For demo purposes the admin access is granted by a switch
<img src="https://github.com/user-attachments/assets/948b7534-e4f9-4abf-80cb-18176a4e2c61" width="300">
<img src="https://github.com/user-attachments/assets/fe477117-1831-4037-9848-e68dda98b3d6" width="300"> 
<img src="https://github.com/user-attachments/assets/dad6a1ff-ec27-4f93-b3ab-f24187881058" width="300">
<br>  </br>

- Admin panel
<br>
<img src="https://github.com/user-attachments/assets/57d79977-2782-44f8-91c8-15daec02c67a" width="300">
<br>
  - Users<br>
<img src="https://github.com/user-attachments/assets/31be821e-9348-4d65-9ad6-6b84254a8138" width="300">
<img src="https://github.com/user-attachments/assets/d2a75f97-7d38-450e-be64-3e5533eb3bf5" width="300">
<img src="https://github.com/user-attachments/assets/fd08d6ee-139f-4e04-9c86-3db7e84b311d" width="300">

- Reviews
<img src="https://github.com/user-attachments/assets/43d6251f-1dff-4bd1-87c3-a3008713a6ff" width="300">
<img src="https://github.com/user-attachments/assets/a3af8265-1743-402a-b6ac-b6f096128d1d" width="300">
<img src="https://github.com/user-attachments/assets/f7ee6bc2-9b8f-4152-8d29-d28bc9bf8244" width="300">






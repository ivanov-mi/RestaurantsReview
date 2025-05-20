# Restaurants Review Demo App

  Recruitment task for iOS job application. It showcases core iOS development skills with a focus on architecture, persistence, and UI design.

## 1. Requirements
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

## 2. Technical Solution Overview

The app adopts a **mobile-first, local-only architecture** to keep development efficient and focused. Instead of a server-based backend, it uses **Core Data** for local storage, simplifying testing and deployment while enabling realistic multi-user functionality.

### Key Technologies & Architecture

- **Xcode 16**, targeting **iOS 17.6**
- **UIKit** with **Storyboard-based UI**
- **MVC** pattern extended with **Coordinators** for navigation
- **Core Data** for on-device persistence
- **Keychain** for secure user ID storage
- **Portrait-only orientation**
- No support for **Dark Mode** or **Dynamic Type** (intentionally omitted for simplicity)

### User Management

- Supports multiple users with role-based access:
  - **Regular User**
  - **Admin**
- Role restrictions apply throughout the interface (e.g., Admin tab access).

### Session Handling

A custom **SessionManager** manages authentication state, integrating with the Keychain for secure user identity storage.

### Project Scope & Limitations

- Unit testing is not included at this stage to maintain a focused scope.
- Certain features (e.g., toggling admin status in Profile) are for demonstration only and would require refinement for production.

---

## 3. Technologies Used & Methodologies Applied

- UIKit and Storyboards
- Custom reusable UI components
- MVC design pattern
- Coordinator pattern for navigation
- Delegation and Singleton patterns
- Keychain integration for secure storage
- Core Data integration
- Session and identity management
- Manual coding (not AI-generated)
- Good code practices and structure

---

## 4. Areas for Improvement

### Codebase
- Refactor and modularize architecture
- Split storyboards for better organization
- Improve Core Data handling
- Add comprehensive error handling
- Implement build configurations
- Integrate dependency injection
- Add unit and UI testing
- Support push/local notifications

### UI/UX
- Fix existing UI bugs
- Improve visual consistency
- Refine UX flow
- Enhance error messaging and empty states
- Add launch screen
- Introduce loading indicators and user feedback

### Functionality
- Filtering and sorting in admin panel
- Sorting options in listing views
- Pull-to-refresh on key screens
- Better Admin panel layout and controls
- Improve Add/Edit Restaurant flow
- Implement Forgot Password functionality
- Enhance Profile features
- Integrate Google NearMe API (future scope)

---

## 5. User Experience Overview

The UX is structured around two main flows:

### 1. Login Flow
- Welcome Screen  
- Login Screen  
- Registration Screen

### 2. Main Flow

The app uses a `MainTabBarController` with three tabs: **Restaurants**, **Profile**, and **Admin**  
(Admin tab is only visible to users with admin rights.)

#### Restaurants Listing (Home)
- Displays all restaurants with basic info
- Selecting a restaurant opens:
  - **Restaurant Details**  
    Includes name, description, average rating, and comments.  
    From here, users can:
    - → **Create Review** – Add a new review
    - → **Review Details** – View full review content (editable if admin or author)

#### Profile
- View user information
- Update profile (limited to admin toggle in this version)
- Logout
- Delete account  
  _Note: Admin toggle is for demo purposes and would not be editable in production._

#### Admin
Accessible only to admin users. It provides management interfaces for:
- **Users**
- **Restaurants**
- **Reviews**

Each is presented using a basic `UITableView`. Detail views reuse:
- **Profile Screen** for user info
- **Restaurant Details Screen** for restaurants
- **Review Details Screen** for reviews



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






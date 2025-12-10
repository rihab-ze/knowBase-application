# KnowBase Application

## 🎯 Purpose of the Application

This application serves as a complete blogging platform allowing users to create, read, interact with, and manage blog posts. It includes role-based access, user interaction features (likes and comments), and automated notifications to authors.

![Article list screenshot](Project/Sources/Shared/visuals/articleList.png)



---

## 🧩 What the Application Covers

### 🏠 Main Features

- Interactive Datatable to browse blog posts
- Dedicated blog post pages (full content view)

- CRUD workflows for writing, editing, and publishing posts

![Article list screenshot](Project/Sources/Shared/visuals/newArticle.png)

- Ability to read, write, like, and comment on blog posts

![Article list screenshot](Project/Sources/Shared/visuals/articleDetail.png)

- Automatic email notifications sent to the blog owner when their post receives a like or comment

- Built-in notification settings allowing each user to enable/disable alerts

![Article list screenshot](Project/Sources/Shared/visuals/settingPage.png)

- Public users can read blogs

- Secure role-based access management

---

### 👥 User Roles


- **Admin**  
Full access to all blog posts and user content. Can write, edit, delete any post, manage comments, manage users, and configure notification settings globally.

- **Tutor**  
  Can create and manage their own blog posts, edit or delete their content, and respond to comments. Can enable/disable notifications for interactions on their posts.

- **Learner**  
  Can read blog posts, like them, and add comments. 

---


## 🚀 How to Integrate and Use the Application

### 1. Clone or Import the Template

Download or clone the project from the Github project link : ###.

### 2. Configure Credentials
To enable the mailing feature, add your credentials in the secret settings page located in the Settings section.


### 3. Launch the Application
To access and start using the application, open the project in Qodly Studio and run the application.

You can choose your preferred starting page depending on your workflow:
- Set the starting page to Index if you want an overview of the entire application and its features.
- Set the starting page to home if you want to land directly on the login process.
 
Open the project in **Qodly Studio** and run the application.  
Explore the different pages to see all available features.

### 4. Test With Different Roles
Log in using predefined test accounts or create new ones to test role behavior:

- **Admin**
- **Tutor**
- **Learner**

Each role will present different permissions and interface options.

### 5. Customize as Needed

Feel free to extend the application according to your needs:

- Modify or expand the **data model**
- Add or redesign **UI elements**
- Implement new **custom components**
- Enhance or change the **business logic** (e.g., approval flow, notifications)



<h1 align="center">👶 Babylo 💛</h1>
<p align="center">
  <img src="banner.gif" alt="Babylo banner" />
</p>

Babylo is a comprehensive app designed to help parents track their babies' and kids' growth, health, doctor appointments, and vaccinations. It also features a built-in music player 🎵 and a collection of audio books 📚 to entertain and educate your little ones. Clone this repo and explore the app to see how it can make parenting easier and more enjoyable!


## Onboarding Screen 🚀

Babylo includes an engaging onboarding screen that provides a quick introduction to the app's features for new users. This helps users to quickly understand the app's functionality and start using it more efficiently.

The onboarding screen is displayed when the app is installed and opened for the first time, guiding users through the main features of the app, such as tracking baby growth, managing doctor appointments, and accessing a music player and audiobooks for kids.

<p align="center">
<img src="https://github.com/Houdalar/Babylo-ios/blob/music/Babylo/images/intro.gif" alt="login" width="300" /> 
</p>

## 🌟 Features

### 🔒 Secure Authentication

Babylo uses a secure authentication system to protect your child's data. Sign up with an email and password, and enjoy the app knowing that your child's information is safe and secure.

<p align="center">
  <img src="https://github.com/Houdalar/Babylo-ios/blob/music/Babylo/images/login.png" alt="login" width="300" /> 
  <img src="https://github.com/Houdalar/Babylo-ios/blob/music/Babylo/images/signup.png" alt="register screenshot" width="300" /> 
  <img src="https://github.com/Houdalar/Babylo-ios/blob/music/Babylo/images/reset1.png" alt="register screenshot" width="300" /> 
  <img src="https://github.com/Houdalar/Babylo-ios/blob/music/Babylo/images/reset2.png" alt="register screenshot" width="300" /> 
  <img src="https://github.com/Houdalar/Babylo-ios/blob/music/Babylo/images/reset3..png" alt="register screenshot" width="300" /> 
  </p>
    

### 📏 Growth and Health Tracking

Keep track of your child's growth, milestones, and health information all in one place. Monitor their height, weight, and head circumference, and compare them to standard growth charts.

<p align="center">
  <img src="growth_tracking.png" alt="Growth tracking screenshot" width="300" />
</p>

### 🗓️ Doctor Appointments and Vaccines 💉

Never miss a doctor's appointment or vaccine with Babylo's built-in scheduling feature. Set reminders and get notified of upcoming appointments and vaccines.

<p align="center">
  <img src="appointments.png" alt="Appointments screenshot" width="300" />
</p>

### 🎶 Music Player

Babylo comes with a built-in music player, allowing you to create playlists and enjoy a wide variety of music suitable for babies and kids.

<p align="center">
   <img src="https://github.com/Houdalar/Babylo-ios/blob/music/Babylo/images/music-overview.png" alt="login" width="300" />
    <img src="https://github.com/Houdalar/Babylo-ios/blob/music/Babylo/images/music.gif" alt="login" width="300" /> 
    <img src="https://github.com/Houdalar/Babylo-ios/blob/music/Babylo/images/tracks.png" alt="login" width="300" /> 
    <img src="https://github.com/Houdalar/Babylo-ios/blob/music/Babylo/images/playlist.png" alt="login" width="300" /> 
    <img src="https://github.com/Houdalar/Babylo-ios/blob/music/Babylo/images/playlis2.png" alt="login" width="300" /> 

</p>

### 📖 Audio Books

Explore our collection of audio books perfect for bedtime stories or keeping your child entertained during the day.

<p align="center">
  <img src="audio_books.png" alt="Audio books screenshot" width="300" />
</p>

## 🚀 Getting Started

To get started with Babylo, clone the repository and follow the steps below:

1. Make sure you have the `latest version` of Xcode installed.
2. Open the `.xcodeproj` file in Xcode.
3. Choose your desired simulator or connect your iOS device.
4. Click the "Run" button or press `Cmd + R` to build and run the project.

## 🐳 Docker Setup for Backend

To get the backend up and running using Docker, follow these simple steps:

1. Install [Docker](https://www.docker.com/get-started) on your machine if you haven't already.

2. Clone the repository:
```
git clone https://github.com/yourusername/babylo.git
cd babylo
```

3. Navigate to the backend folder:
```
cd backend
```

4. Build the Docker image:
```
docker build -t babylo-backend .
```

5. Run the Docker container:
```
docker run -p 8080:8080 --name babylo-backend-container babylo-backend
```

Your backend should now be up and running on port 8080. You can now proceed to set up the frontend to connect with the backend.

To stop the Docker container, run:
```
docker stop babylo-backend-container
```

To start the container again, run:
```
docker start babylo-backend-container
```


## 🤝 Contributing

We welcome contributions to Babylo! Feel free to open an issue, submit a pull request, or share your feedback. Together, we can make Babylo even better! 🌈

## 📜 License

Babylo is released under the [MIT License](LICENSE).

## 🙋 Support

If you have any questions or need help, please feel free to reach out or open an issue. We're here to help! 💬

Happy parenting! 🎉💛

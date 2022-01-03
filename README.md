# The-Rhetorical-Gazebo Mobile Client

# Home Page<br>

<img src="https://therhetoricalgazebo-media.s3.us-east-2.amazonaws.com/Screenshot_20211122-170009.jpg" alt="drawing" width="200"/>

# Installation

After cloning the repo, you will need the Flutter SDK. To install Flutter, please visit
https://docs.flutter.dev/get-started/install.<br/>
Once Flutter is installed and you have confirmed that no signifcant dependencies are
missing with the **flutter doctor** instruction, in the root directory of the project, run
**flutter pub get**. If in Visual Studio Code, there should be a **run** option in the application's
menu at the top of your window. Otherwise, run the **flutter run --no-sound-null-safety** command. If you do not provide the **--no-sound-null-safety** options, you may get an error saying certain packages don't support null safety. If you have done the above, the application should now be
running!<br/>
If you're encountering an error still, try moving to the **android** directory in the project with a **cd** command and run
**./gradlew --refresh-dependencies**. This will take a minute or two. If you're still having trouble running the application
locally or on a device of your choice, please reach out, and we'll be able to help with any inconveniences.
#Using the application
The application has two parts, content upload and content reading. Uploading content requires an account as well as approval
from a Rhetorical Gazebo administrator. For instance, here is the registration page for becoming a writer.<br/>
<img src="https://therhetoricalgazebo-media.s3.us-east-2.amazonaws.com/Screenshot_20211122-165745.jpg" alt="drawing" width="200"/>

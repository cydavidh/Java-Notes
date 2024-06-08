Struts 2 In Action Sample Application

**Contents of the Sample Code Download**

This download contains two web applications.  These are contained in the 
two WAR files: Struts2InAction.war and HelloWorld.war.  The first of these
is the sample application for the entire book.  The second is a special
version of the HelloWorld Struts 2 application that can be used as a 
Struts 2 skeleton.  It contains nothing but the Struts 2 HelloWorld
code, from Chapter Two, and the minimal set of Struts 2 resources.  

While HelloWorld.war provides a convenient example of a minimal Struts 2
application, Struts2InAction.war represents the actual sample code of the book.
This modularized application contains all of the sample code for the entire
book, including the full featured Struts 2 Portfolio.  This single Struts 2 
web application actually contains a number of sub-applications.  Struts 2 
applications, modularized each with their own configuration files, JSP 
directories, and Java package space.  These modular applications basically 
map to the different chapters of the book.  The text of the book always 
takes pains to point you to the right application.  The home page of the
application as a whole has links to the various sub-applications which 
pertain to the different chapters.

Note, the first eight chapters have their complete Java source contained
within chapter specific packages, such as manning.chapterFour.  The 
latter chapters, starting with Chapter 9, follow this pattern, but 
share a higher level package called manning.utils.  Earlier chapters 
have their own version of utils, such as manning.chapterFour.utils.  This
shouldn't matter to you, but it might be a bit confusing if you don't
know.

**Purpose of the Sample Application**

This sample application aims to provide a thorough and clean demonstration
of all of the core features of the Struts 2 framework, and also provide a real
world case study of a full featured Struts 2 application.  The version of the 
sample application pertaining to each chapter of the book attempts to focus
the sample code on the lessons at hand.  After the introductory HelloWorld
sub-applications, a full featured application will be developed incrementally
through out the course of the book.  This application, the "Struts 2 Portfolio",
will increase in complexity with each chapter's contributions.  Nonetheless, 
the focus of a given chapter's sample code will be on the topics of that 
chapter.

When you start the book, the sample application will be rudimentary and 
incomplete. The only purpose of early versions is to make the demonstration of 
the early core topics unclouded by advanced topics such as Spring integration or
CRUD actions.  But by the latter chapters, one can expect that the correspondent
version of the Struts 2 Portfolio to be quite full featured.  Though you might
still have to "flip" back to the Chapter Eight version to see how to integrate
Ajax with a custom Result.

**Sample Application Project Structure**

While many people believe that their build and development process may be 
standard, there will always be others who believe another set of tools and
practices, the ones they use, are more standard.  We have decided to 
to keep this samplecode build tool and development process independent.  The 
sample code that you will find zipped with this document is a ready to deploy 
war file.  It contains all the jar files that it depends on and even contains
its full source code.  If you would like to promptly break this apart into an 
Ant or Maven project structure, feel free -- we certainly would!  

All of the source is located in a 'src' directory inside the web application's 
WEB-INF folder.  This 'src' folder also contains other resources such as 
configuration files and properties files.  However, the web application comes
fully built and ready to roll.

**Setting up the Application**

There are a few details to attend to if you want everything to run smoothly out 
of the box.  

Database:
Latter chapters use the Java Persistence API to implement the data layer.  As
it stands, this is configured to run with MySQL with a certain username and 
password.  Configuration of this database connection information is found 
entirely at /WEB-INF/applicationContext.xml -- this Spring configuration file.
The early versions of the application will probably still run in the face of 
a lack of database connectivity, though you will certainly see errors in the 
logs.  JPA can pretty much run with any database you might have, so configuring
this shouldn't amount to much.  If you choose another database than MySQL, 
you'll need to get a driver.  In all cases, you'll need to set up the db account
and give it the right privelages. 

Filesystem Path: 
Another bit of configuration is the path to the file system location for writing 
uploaded images.  This is set in several places.  For early chapters, you can 
set this in the sub application's struts.xml file, for example in Chapter 6's
/WEB-INF/classes/manning/chapterSix/chapterSix.xml file.  The setting is located 
in the declaration element for the ImageUpload action.  In these chapters,
we just write the images to a directory relative to the server itself.  
Starting with chapter nine, we will set the value of the path with Spring.
This can be set in the Spring applicationContext.xml file on the bean
declaration element for the portfolioService.  Now, the application will
store the uploaded images in an images directory of the web app's doc root.  
You'll need to change this if you want Chatpers Nine and up to work.

Default User Accounts:
You will want to log in to the sample application for demoing various features.  
In chapters 1-8, you can use one of several built-in accounts.  All of these
can be seen by looking in that chapter's PortfolioService class.  This class
will be in the util package, such as 
manning.chapterThree.utils.PortfolioService.  The built-in accounts can be seen
in the static init block that defines the Map of users.  You can always count 
on the Arty/password (username/password) account. 

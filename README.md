<h1>Website Voting</h1>

<p>By Tawana Jerome and Rachel Klesius</p>

<h2>Project description: </h2>
<p> This project is a web application that allows an instructor to upload a zip file of html documents for students to vote for their first, second, and third favorite of those websites.  Each student can only vote once, and once at least one student has voted, the instructor can log back in and see the results of the voting polls.  This web application also implements a login feature that also helps differentiate the user's role (either student or instructor).  This login and password information is inputted through a csv file upload.  

<h2>How to run:</h2>
<p> To run this program, you need the following gems:
    <ul>
        <li>sinatra</li>
        <li>sinatra-contrib</li>
        <li>data_mapper</li>
        <li>bcrypt</li>
        <li>csv</li>
        <li>rubyzip</li>
        <li>sqlite</li>
    </ul>
</p>

<h2>How to use:</h2>
<p>
   You have the option of uploading your own csv file or just using the csv we provided. Please be aware that your csv needs to be in the form of username,name,password,role. Once you upload your csv you will then be redirected to the actual login page. Login using any username and password provided in the csv file.  On the instructor page, you can upload a zip file of html documents.
</p>

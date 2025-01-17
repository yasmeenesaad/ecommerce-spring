<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chicly - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/login.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .icon {
            color: #4285F4; /* Google Blue */
            margin-right: 5px; /* Space between icon and text */
        }
        .facebook-icon {
            color: #3b5998; /* Facebook Blue */
            margin-right: 5px;
        }
        .github-icon {
            color: #333; /* GitHub Black */
            margin-right: 5px;
        }
        .signin-icons {
            display: block; /* Stack the links vertically */
            margin-bottom: 10px; /* Space between links */
        }
    </style>
</head>
<body>
<div class="card login-container">
    <div id="message-container"></div> <!-- Message container for alerts -->

    <div class="login-logo">
        <img src="img/logo.png" alt="Chicly Logo">
    </div>
    <div class="login-form">
        <form id="loginform">
            <h3 class="signin-heading">SIGN IN</h3>
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
            </div>
            <div class="signin-icons">

                <a href="https://accounts.google.com/o/oauth2/v2/auth?redirect_uri=http://localhost:8083/grantcode&response_type=code&client_id=500520249170-r75a36k8tkdqfpm0dka0tci28vq881ke.apps.googleusercontent.com&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+openid&access_type=offline">
                    <i class="fab fa-google icon"></i> Sign in with Google
                </a> <br>
                <a href="https://www.facebook.com/v15.0/dialog/oauth?client_id=1056032482652267&redirect_uri=http://localhost:8083/login/oauth2/code/facebook&scope=email,public_profile&response_type=code">                    <i class="fab fa-facebook facebook-icon"></i> Sign in with Facebook
                </a><br>
                <a href="https://github.com/login/oauth/authorize?client_id=Ov23liFHDlx4fenno3Su&redirect_uri=http://localhost:8083/login/oauth2/code/github&scope=user:email">
                    <i class="fab fa-github github-icon"></i> Sign in with GitHub
                </a>

            </div>
            <div class="sign-up form-group text-center">
                <p>Not a member? <a href="registration.jsp">
                    signup now <i class="fas fa-user-plus"></i></a></p>
            </div>
        </form>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        $('#loginform').on('submit', function(event) {
            event.preventDefault(); // Prevent default form submission

            // Get form data
            var username = $('#username').val();
            var password = $('#password').val();

            // Make AJAX request to login
            $.ajax({
                url: '/auth/login', // Your API endpoint
                method: 'POST',
                contentType: 'application/json', // Sending JSON
                data: JSON.stringify({
                    username: username,
                    password: password
                }),
                success: function(response) {
                    const token = response['jwt-token']
                    const username = response['username']
                    const role = response['role']
                    sessionStorage.setItem("jwt-token",token);
                    sessionStorage.setItem("username",username);
                    sessionStorage.setItem("role",role);
                    if(role==="admin"){
                        window.location.href = '/admin/adminDashboard.jsp';
                    }
                    else{
                        window.location.href = 'index.jsp';
                    }
                },
                error: function(xhr) {
                    // Handle error response
                    var errorMessage = xhr.responseJSON ? xhr.responseJSON.message : 'An unexpected error occurred.';
                    showMessage('Invalid username or password', 'danger');
                }
            });
        });


        function showMessage(message, type) {
            // Determine the alert type based on the message type
            var alertType = type === 'success' ? 'alert-success' : 'alert-danger';

            // Choose the appropriate icon based on the message type
            var iconClass = type === 'success' ? 'fas fa-check-circle' : 'fas fa-exclamation-triangle';

            var alertHtml = '<div class="alert alert-' + type + ' text-center" style="width: fit-content; margin: 0 auto;color: red;">' + message + '</div>';
            $('.card').prepend(alertHtml);
            setTimeout(function() {
                $('.alert').fadeOut('slow', function() {
                    $(this).remove();
                });
            }, 3000);  // Automatically remove alert after 3 seconds
        }

    });
</script>
<script>
	function removeQueryParam() {
		const url = window.location.protocol + "//" + window.location.host + window.location.pathname;
		window.history.replaceState({}, document.title, url);
	}
</script>
</body>
</html>
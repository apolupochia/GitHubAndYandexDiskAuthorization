

import Foundation

enum GitInfo : String{
    case login = "myGithubLoginForSecretPass"

    case clientId = "your_client_id"
    case clientSecret = "your_client_secret"

    case reposUrl =  "https://api.github.com/user/repos"
    case authorizeUrl = "https://github.com/login/oauth/authorize"
    case redirectUri = "it.iacopo.github://authentication"
    case redirectUrlLogout = "https://github.com"
    case scope = "user repo"
    case logoutCallbackUrl = "ru.kts.oauth://github.com/logout_callback"
    case logoutUrl = "https://github.com/logout"
    
    case fileCellIdentifireGitMain = "FileTableViewCellGitMain"
    case fileCellIdentifireGitInfInRepo = "FileTableViewCellGitInfInRepo"
}



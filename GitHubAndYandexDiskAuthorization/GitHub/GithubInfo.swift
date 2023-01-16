

import Foundation

enum GitInfo : String{
    case login = "myGithubLoginForSecretPass"
    
    case client_id = "your_client_id"
    case client_secret = "your_client_secret"

    case redirect_uri = "it.iacopo.github://authentication"
    case scope = "user repo"
    case logoutCallbackUrl = "ru.kts.oauth://github.com/logout_callback"
    
    case fileCellIdentifireGitMain = "FileTableViewCellGitMain"
    case fileCellIdentifireGitInfInRepo = "FileTableViewCellGitInfInRepo"
}

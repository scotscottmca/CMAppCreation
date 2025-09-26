function New-RandomDescription {
    $Adjectives = @(
        "powerful", "innovative", "intuitive", "user-friendly", "cutting-edge", "reliable", "scalable", "secure", "versatile", "dynamic",
        "efficient", "robust", "modern", "advanced", "customizable", "seamless", "intelligent", "streamlined", "comprehensive", "flexible"
    )

    $Verbs = @(
        "delivers", "provides", "offers", "enables", "facilitates", "enhances", "optimizes", "simplifies", "supports", "empowers"
    )

    $Nouns = @(
        "solutions", "tools", "platforms", "features", "capabilities", "services", "technologies", "applications", "frameworks", "systems"
    )

    $Phrases = @(
        "for businesses", "for users", "for developers", "for enterprises", "for organizations", "for teams", "for individuals",
        "to improve productivity", "to streamline workflows", "to enhance performance", "to drive innovation", "to achieve goals",
        "to simplify tasks", "to ensure security", "to boost efficiency", "to foster collaboration", "to deliver results"
    )

    $Description = @()
    $Description += $Adjectives | Get-Random
    $Description += $Verbs | Get-Random
    $Description += $Nouns | Get-Random
    $Description += $Phrases | Get-Random
    $Description += $Phrases | Get-Random

    return ($Description -join " ") + "."
}
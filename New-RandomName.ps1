function New-RandomName {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("App", "Company")]
        [string]$Type
        )

    $AppAdjectives = @(
        "Silent", "Golden", "Crystal", "Swift", "Mighty", "Frozen", "Infinite", "Azure", "Bold", "Quantum", 
        "Burning", "Radiant", "Hidden", "Ancient", "Blazing", "Nebula", "Thunder", "Whispering", "Echo", "Solar",
        "Glowing", "Vivid", "Mystic", "Wild", "Dark", "Eternal", "Bright", "Shimmering", "Dreaming", "Brilliant",
        "Steel", "Flawless", "Fading", "Majestic", "Grim", "Primal", "True", "Pure", "Elegant", "Serene",
        "Clever", "Savage", "Lost", "Forgotten", "Rising", "Emerald", "Scarlet", "Frozen", "Icy", "Roaring",
        "Endless", "Glacial", "Verdant", "Soaring", "Iron", "Velvet", "Obsidian", "Titanic", "Stormy", "Thundering",
        "Radiant", "Eclipsed", "Enigmatic", "Silver", "Gleaming", "Fiery", "Cosmic", "Galactic", "Starry", "Twilight",
        "Nocturnal", "Shadowed", "Burnished", "Gilded", "Infernal", "Celestial", "Vengeful", "Transcendent", "Fabled",
        "Undying", "Flickering", "Blazing", "Merciless", "Wicked", "Noble", "Spectral", "Aurora", "Mirrored", "Frosted",
        "Cursed", "Blessed", "Boundless", "Vigilant", "Luminous", "Mystical", "Shattered", "Veiled", "Dreadful", "Severed",
        "Global", "Dynamic", "Innovative", "Advanced", "Strategic", "Premier", "Elite", "NextGen", "Pioneer", "Leading",
        "Visionary", "Synergy", "Proactive", "Agile", "Sustainable", "Reliable", "Trusted", "Efficient", "CuttingEdge", "Future",
        "Progressive", "Modern", "Unified", "Collaborative", "Smart", "Intelligent", "Creative", "Bold", "Ambitious", "Driven",
        "Focused", "Dedicated", "Committed", "Passionate", "Energetic", "Vibrant", "Versatile", "Adaptable", "Resilient",
        "Robust", "Scalable", "Flexible", "Pioneering", "Trailblazing", "Groundbreaking", "Revolutionary", "Transformative",
        "Disruptive", "ForwardThinking", "FutureFocused", "CustomerCentric", "UserFriendly", "ClientFocused", "ServiceOriented",
        "QualityDriven", "ExcellenceDriven", "PerformanceDriven", "ResultsOriented", "OutcomeFocused", "ValueDriven", "IntegrityDriven",
        "Ethical", "Transparent", "Accountable", "Responsible", "EcoFriendly", "Green", "EnvironmentallyConscious", "SociallyResponsible",
        "CommunityFocused", "Inclusive", "Diverse", "Equitable", "Fair", "Just", "Honest", "Trustworthy", "Dependable", "Consistent",
        "Stable", "Secure", "Safe", "Protected", "Guarded", "Shielded", "Defended", "Fortified", "Reinforced", "Strengthened",
        "Empowered", "Enabled", "Supported", "Assisted", "Guided", "Mentored", "Coached", "Trained", "Educated", "Informed",
        "Knowledgeable", "Experienced", "Skilled", "Expert", "Professional", "Qualified", "Certified", "Accredited", "Licensed",
        "Authorized", "Approved", "Endorsed", "Recommended", "Preferred", "Chosen", "Selected", "Picked", "Handpicked", "Curated",
        "Tailored", "Customized", "Personalized", "Individualized", "Unique", "Distinctive", "Original", "Artistic", "Inventive",
        "Imaginative", "Resourceful", "Ingenious", "Bright", "Brilliant", "Genius", "Wise", "Sage", "Learned", "Scholarly",
        "Academic", "Erudite", "Cultured", "Sophisticated", "Refined", "Elegant", "Stylish", "Chic", "Trendy", "Fashionable",
        "Contemporary", "Current", "UpToDate", "StateOfTheArt", "HighTech", "LeadingEdge"
    )
    
    $CompanyAdjectives = @(
        "Global", "Dynamic", "Innovative", "Advanced", "Strategic", "Premier", "Elite", "NextGen", "Pioneer", "Leading",
        "Visionary", "Synergy", "Proactive", "Agile", "Sustainable", "Reliable", "Trusted", "Efficient", "CuttingEdge", "Future",
        "Progressive", "Modern", "Unified", "Collaborative", "Smart", "Intelligent", "Creative", "Bold", "Ambitious", "Driven",
        "Focused", "Dedicated", "Committed", "Passionate", "Energetic", "Vibrant", "Versatile", "Adaptable", "Resilient",
        "Robust", "Scalable", "Flexible", "Pioneering", "Trailblazing", "Groundbreaking", "Revolutionary", "Transformative",
        "Disruptive", "ForwardThinking", "FutureFocused", "CustomerCentric", "UserFriendly", "ClientFocused", "ServiceOriented",
        "QualityDriven", "ExcellenceDriven", "PerformanceDriven", "ResultsOriented", "OutcomeFocused", "ValueDriven", "IntegrityDriven",
        "Ethical", "Transparent", "Accountable", "Responsible", "EcoFriendly", "Green", "EnvironmentallyConscious", "SociallyResponsible",
        "CommunityFocused", "Inclusive", "Diverse", "Equitable", "Fair", "Just", "Honest", "Trustworthy", "Dependable", "Consistent",
        "Stable", "Secure", "Safe", "Protected", "Guarded", "Shielded", "Defended", "Fortified", "Reinforced", "Strengthened",
        "Empowered", "Enabled", "Supported", "Assisted", "Guided", "Mentored", "Coached", "Trained", "Educated", "Informed",
        "Knowledgeable", "Experienced", "Skilled", "Expert", "Professional", "Qualified", "Certified", "Accredited", "Licensed",
        "Authorized", "Approved", "Endorsed", "Recommended", "Preferred", "Chosen", "Selected", "Picked", "Handpicked", "Curated",
        "Tailored", "Customized", "Personalized", "Individualized", "Unique", "Distinctive", "Original", "Artistic", "Inventive",
        "Imaginative", "Resourceful", "Ingenious", "Bright", "Brilliant", "Genius", "Wise", "Sage", "Learned", "Scholarly",
        "Academic", "Erudite", "Cultured", "Sophisticated", "Refined", "Elegant", "Stylish", "Chic", "Trendy", "Fashionable",
        "Contemporary", "Current", "UpToDate", "StateOfTheArt", "HighTech", "LeadingEdge", "Strategic", "Premier", "Elite", "NextGen",
        "Pioneer", "Leading", "Visionary", "Synergy", "Proactive", "Agile", "Sustainable", "Reliable", "Trusted", "Efficient",
        "CuttingEdge", "Future", "Progressive", "Modern", "Unified", "Collaborative", "Smart", "Intelligent", "Creative", "Bold",
        "Ambitious", "Driven", "Focused", "Dedicated", "Committed", "Passionate", "Energetic", "Vibrant", "Versatile", "Adaptable",
        "Resilient", "Robust", "Scalable", "Flexible", "Pioneering", "Trailblazing", "Groundbreaking", "Revolutionary", "Transformative",
        "Disruptive", "ForwardThinking", "FutureFocused", "CustomerCentric", "UserFriendly", "ClientFocused", "ServiceOriented",
        "QualityDriven", "ExcellenceDriven", "PerformanceDriven", "ResultsOriented", "OutcomeFocused", "ValueDriven", "IntegrityDriven",
        "Ethical", "Transparent", "Accountable", "Responsible", "EcoFriendly", "Green", "EnvironmentallyConscious", "SociallyResponsible",
        "CommunityFocused", "Inclusive", "Diverse", "Equitable", "Fair", "Just", "Honest", "Trustworthy", "Dependable", "Consistent",
        "Stable", "Secure", "Safe", "Protected", "Guarded", "Shielded", "Defended", "Fortified", "Reinforced", "Strengthened",
        "Empowered", "Enabled", "Supported", "Assisted", "Guided", "Mentored", "Coached", "Trained", "Educated", "Informed",
        "Knowledgeable", "Experienced", "Skilled", "Expert", "Professional", "Qualified", "Certified", "Accredited", "Licensed",
        "Authorized", "Approved", "Endorsed", "Recommended", "Preferred", "Chosen", "Selected", "Picked", "Handpicked", "Curated",
        "Tailored", "Customized", "Personalized", "Individualized", "Unique", "Distinctive", "Original", "Artistic", "Inventive",
        "Imaginative", "Resourceful", "Ingenious", "Bright", "Brilliant", "Genius", "Wise", "Sage", "Learned", "Scholarly",
        "Academic", "Erudite", "Cultured", "Sophisticated", "Refined", "Elegant", "Stylish", "Chic", "Trendy", "Fashionable",
        "Contemporary", "Current", "UpToDate", "StateOfTheArt", "HighTech", "LeadingEdge"
    )
    
    $CompanyNouns = @(
        "Solutions", "Technologies", "Systems", "Enterprises", "Industries", "Holdings", "Corporation", "Group", "Partners", "Ventures",
        "Consulting", "Services", "Networks", "Dynamics", "Innovations", "Concepts", "Developments", "Resources", "Strategies", "Operations",
        "Pioneer", "Explorer", "Navigator", "Voyage", "Journey", "Odyssey", "Quest", "Adventure", "Expedition", "Mission",
        "Discovery", "Innovation", "Creation", "Invention", "Design", "Concept", "Idea", "Vision", "Dream", "Aspiration",
        "Goal", "Objective", "Target", "Aim", "Purpose", "Intention", "Plan", "Strategy", "Tactic", "Approach",
        "Method", "Technique", "Procedure", "Process", "System", "Framework", "Model", "Structure", "Architecture", "Blueprint",
        "Pattern", "Template", "Prototype", "Sample", "Example", "Instance", "Case", "Scenario", "Situation", "Context",
        "Environment", "Setting", "Background", "Landscape", "Scene", "View", "Perspective", "Outlook", "Vision", "Insight",
        "Understanding", "Knowledge", "Wisdom", "Intelligence", "Information", "Data", "Facts", "Evidence", "Proof", "Validation",
        "Verification", "Confirmation", "Approval", "Endorsement", "Recommendation", "Suggestion", "Advice", "Guidance", "Direction", "Instruction",
        "Command", "Order", "Request", "Demand", "Requirement", "Need", "Necessity", "Essential", "Priority", "Preference",
        "Choice", "Option", "Alternative", "Selection", "Decision", "Judgment", "Conclusion", "Resolution", "Solution", "Answer",
        "Response", "Reaction", "Feedback", "Comment", "Opinion", "Viewpoint", "Perspective", "Standpoint", "Position", "Stance",
        "Attitude", "Approach", "Mindset", "Outlook", "Belief", "Faith", "Trust", "Confidence", "Reliance", "Dependence",
        "Support", "Assistance", "Help", "Aid", "Benefit", "Advantage", "Gain", "Profit", "Reward", "Return",
        "Outcome", "Result", "Effect", "Impact", "Influence", "Consequence", "Repercussion", "Ramification", "Implication", "Significance",
        "Importance", "Value", "Worth", "Merit", "Excellence", "Quality", "Standard", "Level", "Grade", "Rank",
        "Status", "Position", "Role", "Function", "Duty", "Responsibility", "Obligation", "Commitment", "Dedication", "Devotion",
        "Passion", "Enthusiasm", "Energy", "Vigor", "Vitality", "Strength", "Power", "Force", "Might", "Authority",
        "Control", "Command", "Leadership", "Management", "Administration", "Governance", "Direction", "Supervision", "Oversight", "Regulation",
        "Pioneer", "Explorer", "Navigator", "Voyage", "Journey", "Odyssey", "Quest", "Adventure", "Expedition", "Mission",
        "Discovery", "Innovation", "Creation", "Invention", "Design", "Concept", "Idea", "Vision", "Dream", "Aspiration",
        "Goal", "Objective", "Target", "Aim", "Purpose", "Intention", "Plan", "Strategy", "Tactic", "Approach",
        "Method", "Technique", "Procedure", "Process", "System", "Framework", "Model", "Structure", "Architecture", "Blueprint",
        "Pattern", "Template", "Prototype", "Sample", "Example", "Instance", "Case", "Scenario", "Situation", "Context",
        "Environment", "Setting", "Background", "Landscape", "Scene", "View", "Perspective", "Outlook", "Vision", "Insight",
        "Understanding", "Knowledge", "Wisdom", "Intelligence", "Information", "Data", "Facts", "Evidence", "Proof", "Validation",
        "Verification", "Confirmation", "Approval", "Endorsement", "Recommendation", "Suggestion", "Advice", "Guidance", "Direction", "Instruction",
        "Command", "Order", "Request", "Demand", "Requirement", "Need", "Necessity", "Essential", "Priority", "Preference",
        "Choice", "Option", "Alternative", "Selection", "Decision", "Judgment", "Conclusion", "Resolution", "Solution", "Answer",
        "Response", "Reaction", "Feedback", "Comment", "Opinion", "Viewpoint", "Perspective", "Standpoint", "Position", "Stance",
        "Attitude", "Approach", "Mindset", "Outlook", "Belief", "Faith", "Trust", "Confidence", "Reliance", "Dependence",
        "Support", "Assistance", "Help", "Aid", "Benefit", "Advantage", "Gain", "Profit", "Reward", "Return",
        "Outcome", "Result", "Effect", "Impact", "Influence", "Consequence", "Repercussion", "Ramification", "Implication", "Significance",
        "Importance", "Value", "Worth", "Merit", "Excellence", "Quality", "Standard", "Level", "Grade", "Rank",
        "Status", "Position", "Role", "Function", "Duty", "Responsibility", "Obligation", "Commitment", "Dedication", "Devotion",
        "Passion", "Enthusiasm", "Energy", "Vigor", "Vitality", "Strength", "Power", "Force", "Might", "Authority",
        "Control", "Command", "Leadership", "Management", "Administration", "Governance", "Direction", "Supervision", "Oversight", "Regulation"
    )
    
    $AppNouns = @(
        "Wave", "Sky", "Fortress", "Stream", "Guardian", "Flame", "Depth", "Vision", "Core", "Forge", 
        "Echo", "Dream", "Path", "Realm", "Sphere", "Peak", "Vale", "Dawn", "Pulse", "Frontier",
        "Keeper", "Stone", "Blade", "Scroll", "Shroud", "Crest", "Fury", "Spirit", "Shield", "Song",
        "Haven", "Torch", "Scepter", "Vortex", "Drake", "Tide", "Ash", "Banner", "Quest", "Rune",
        "Temple", "Bane", "Rift", "Cloak", "Oath", "Requiem", "Storm", "Cycle", "Warden", "Veil",
        "Crown", "Phoenix", "Chaos", "Aegis", "Haven", "Tyrant", "Sigil", "Ember", "Spire", "Glory",
        "Knight", "Raven", "Crypt", "Fang", "Wing", "Hollow", "Haven", "Tide", "Lore", "Relic",
        "Sun", "Moon", "Star", "Eclipse", "Thunder", "Blight", "Frost", "Steel", "Beacon", "Throne",
        "Guardian", "Sage", "Prophet", "Oracle", "Serpent", "Legion", "Aspect", "Inferno", "Drifter", "Voyager",
        "Specter", "Marauder", "Seeker", "Fate", "Beacon", "Champion", "Watcher", "Warden", "Ascendant", "Conqueror",
        "Vanguard", "Phantom", "Cobra", "Hawk", "Bastion", "Verdict", "Reaper", "Haven", "Paragon", "Shade",
        "Blade", "Torrent", "Cipher", "Sanctuary", "Wisp", "Brigade", "Flare", "Rapture", "Bloom", "Grove",
        "Pioneer", "Explorer", "Navigator", "Voyage", "Journey", "Odyssey", "Quest", "Adventure", "Expedition", "Mission",
        "Discovery", "Innovation", "Creation", "Invention", "Design", "Concept", "Idea", "Vision", "Dream", "Aspiration",
        "Goal", "Objective", "Target", "Aim", "Purpose", "Intention", "Plan", "Strategy", "Tactic", "Approach",
        "Method", "Technique", "Procedure", "Process", "System", "Framework", "Model", "Structure", "Architecture", "Blueprint",
        "Pattern", "Template", "Prototype", "Sample", "Example", "Instance", "Case", "Scenario", "Situation", "Context",
        "Environment", "Setting", "Background", "Landscape", "Scene", "View", "Perspective", "Outlook", "Vision", "Insight",
        "Understanding", "Knowledge", "Wisdom", "Intelligence", "Information", "Data", "Facts", "Evidence", "Proof", "Validation",
        "Verification", "Confirmation", "Approval", "Endorsement", "Recommendation", "Suggestion", "Advice", "Guidance", "Direction", "Instruction",
        "Command", "Order", "Request", "Demand", "Requirement", "Need", "Necessity", "Essential", "Priority", "Preference",
        "Choice", "Option", "Alternative", "Selection", "Decision", "Judgment", "Conclusion", "Resolution", "Solution", "Answer",
        "Response", "Reaction", "Feedback", "Comment", "Opinion", "Viewpoint", "Perspective", "Standpoint", "Position", "Stance",
        "Attitude", "Approach", "Mindset", "Outlook", "Belief", "Faith", "Trust", "Confidence", "Reliance", "Dependence",
        "Support", "Assistance", "Help", "Aid", "Benefit", "Advantage", "Gain", "Profit", "Reward", "Return",
        "Outcome", "Result", "Effect", "Impact", "Influence", "Consequence", "Repercussion", "Ramification", "Implication", "Significance",
        "Importance", "Value", "Worth", "Merit", "Excellence", "Quality", "Standard", "Level", "Grade", "Rank",
        "Status", "Position", "Role", "Function", "Duty", "Responsibility", "Obligation", "Commitment", "Dedication", "Devotion",
        "Passion", "Enthusiasm", "Energy", "Vigor", "Vitality", "Strength", "Power", "Force", "Might", "Authority",
        "Control", "Command", "Leadership", "Management", "Administration", "Governance", "Direction", "Supervision", "Oversight", "Regulation"
    )
        
    if ($Type -eq "Company") {
        $Adjective = $CompanyAdjectives | Get-Random
        $Noun = $CompanyNouns | Get-Random
        $Postfixes = @("LLC", "Inc", "Ltd", "Corp", "Group", "PLC", "Co", "Enterprises")
        $Postfix = $Postfixes | Get-Random
        return "$Adjective $Noun $Postfix"
    } else {
        $Adjective = $AppAdjectives | Get-Random
        $Noun = $AppNouns | Get-Random
        return "$Adjective $Noun"
    }
}
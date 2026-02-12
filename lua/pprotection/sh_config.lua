DPP2 = DPP2 or {}

DPP2.Config = {
    core = {
        enabled = true,
        cleanupBatchSize = 60,
        outOfBounds = {
            timerEnabled = true,
            timerSeconds = 60,
            min = Vector(-16384, -16384, -16384),
            max = Vector(16384, 16384, 16384),
            whitelistClasses = {"worldspawn"}
        },
        protectedFrozenEntities = {},
        disconnectedCleanup = {
            timerEnabled = true,
            timerSeconds = 120,
            specificSteamIDs = {}
        },
        blacklist = {}
    },
    ownership = {
        sharedOwnershipMode = false,
        autoTransferOnTeamChange = true,
        forceDarkRPOwnership = true,
        trust = {
            permanent = {},
            temporary = {},
            teamTrust = {}
        },
        logs = true
    },
    ghosting = {
        enabled = true,
        color = Color(80, 170, 255, 120),
        antiObscuringEntities = {},
        ghostOnPhysgun = true,
        useBlacklist = true,
        ghostableEntities = {"prop_physics", "prop_ragdoll"},
        forceGhostUnfrozen = false,
        forceGhostUnfrozenWhitelist = {}
    },
    damage = {
        enabled = true,
        useBlacklist = false,
        blacklistedEntities = {},
        disableBlacklistedEntityDamage = true,
        disableVehicleDamage = false,
        disableWorldDamage = false,
        immortalEntities = {},
        bypassGroups = {"superadmin"},
        canDamageWorldEntities = {"superadmin"}
    },
    antiCollide = {
        enabled = true,
        notifyStaff = true,
        darkRP = {
            protect = true,
            threshold = 125,
            exception = {}
        },
        spawnedEntities = {
            protect = true,
            threshold = 75,
            exception = {}
        },
        spawnedProps = {
            protect = true,
            threshold = 45,
            exception = {}
        },
        specificEntities = {}
    },
    spamProtection = {
        enabled = true,
        spawnThreshold = 45,
        spawnDelay = 1.0,
        punishmentMode = "freeze",
        notifyStaff = true,
        protectProps = true,
        protectEntities = true,
        debounceSeconds = 0.2
    },
    spawnRestriction = {
        enabled = true,
        propPermissions = {},
        sentPermissions = {},
        swepPermissions = {},
        vehiclePermissions = {},
        npcPermissions = {},
        ragdollPermissions = {},
        effectPermissions = {},
        blockedSents = {},
        blockedClassesBlacklist = true,
        blockedModels = {},
        blockedModelsBlacklist = true,
        spawnVehicleBypassBlockedModels = true,
        bypassGroups = {"superadmin"}
    },
    toolgun = {
        enabled = true,
        canTargetWorldEntities = false,
        canTargetPlayerOwnedEntities = true,
        restrictedTools = {},
        groupToolRestrictions = {},
        entityTargetability = {},
        bypassTargetabilityTools = {"remover", "advdupe2"},
        bypassGroups = {"superadmin"},
        antiSpam = true
    },
    physgun = {
        enabled = true,
        canTargetWorldEntities = false,
        canTargetPlayerOwnedEntities = true,
        disableReloadUnfreeze = true,
        pickupVehiclePermission = {},
        stopMotionOnDrop = true,
        blockMultiplePhysgunning = true,
        maxObstructThreshold = 3,
        maxObstructTriggerAction = "freeze",
        blockedEntities = {},
        bypassGroups = {"superadmin"}
    },
    gravgun = {
        enabled = true,
        canTargetWorldEntities = false,
        canTargetPlayerOwnedEntities = true,
        disableGravityGunPunting = true,
        blockedEntities = {},
        bypassGroups = {"superadmin"}
    },
    canProperty = {
        enabled = true,
        canTargetWorldEntities = false,
        canTargetPlayerOwnedEntities = true,
        blockedProperties = {},
        blockedPropertiesBlacklist = true,
        blockedEntities = {},
        bypassGroups = {"superadmin"}
    },
    advDupe2 = {
        enabled = true,
        notifyStaff = true,
        preventRopeSpawning = true,
        preventScaling = true,
        preventNoGravity = true,
        preventTrails = true,
        preventUnreasonableValues = true,
        preventUnfreezeAll = true,
        blacklistedCollisionGroups = {},
        whitelistedConstraints = {"Weld", "NoCollide", "Axis"}
    },
    miscs = {
        enabled = true,
        clearDecalsTimer = 120,
        preventBlackoutExploit = true,
        preventFadingDoorLag = true,
        disableMotionGlobally = false,
        disableMotionEntities = {},
        freezeOnSpawn = false,
        preventFadingDoorAbuse = true,
        preventSpawnNearPlayerDistance = 10,
        maxObstructsOnPurchaseDarkRPEnts = 3,
        maxObstructFilterDarkRPEnts = 1
    },
    logging = {
        enabled = true,
        staffNotifyThrottle = 2,
        console = true,
        file = true
    },
    automation = {
        autoFreezeLargeContraptions = true,
        autoGhostLargeBuilds = true,
        abandonedCleanupMinutes = 120,
        buildAreaSizeLimit = 8000,
        perMapLimits = {},
        perJobLimits = {},
        perRankMultipliers = {}
    },
    crashGuard = {
        enabled = true,
        constraintLimit = 400,
        weldLimit = 250,
        vehicleSpamWindow = 3,
        vehicleSpamThreshold = 10,
        detectParentLoops = true,
        detectRecursiveConstraints = true,
        detectPhysicsExplosions = true,
        detectMassSpawnSpikes = true,
        fpsAutoProtection = true,
        fpsThreshold = 20
    },
    permissions = {
        useCAMI = true,
        fallbackGroups = {"superadmin", "admin"},
        featureOverrides = {}
    }
}

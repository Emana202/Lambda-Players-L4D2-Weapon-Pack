local IsValid = IsValid
local ipairs = ipairs
local istable = istable
local isstring = isstring
local isentity = isentity
local CurTime = CurTime
local random = math.random
local Rand = math.Rand
local util_Effect = util.Effect
local EffectData = EffectData
local TraceLine = util.TraceLine
local ents_Create = ents.Create

local meleeTrTbl = {}
local fireBulletTbl = {}
local defaultDmgForce = { Forward = 75, Right = -50, Up = 0 }
local fireSpreadVec = Vector()

LAMBDA_L4D2 = LAMBDA_L4D2 or {}

function LAMBDA_L4D2:InitializeWeapon( lambda, weapon, ignoreSkins )
    local deploySnd = weapon.L4D2Data.DeploySound
    if isstring( deploySnd ) then
        weapon:EmitSound( deploySnd, 65, 100, 1, CHAN_ITEM )
    elseif istable( deploySnd ) and #deploySnd > 0 then
        local weaponName = lambda:GetWeaponName()
        for _, v in ipairs( deploySnd ) do
            lambda:SimpleTimer( v[ 1 ], function()
                if !IsValid( weapon ) or lambda:GetWeaponName() != weaponName then return end
                weapon:EmitSound( v[ 2 ], 65, 100, 1, CHAN_ITEM )
            end )
        end
    end

    local skinCount = weapon:SkinCount()
    weapon:SetSkin( ( !ignoreSkins and skinCount > 1 and random( 1, 3 ) == 1 ) and random( 0, skinCount - 1 ) or 0 )
end

local meleeSwingSounds = {
    Sound( "lambdaplayers/weapons/l4d2/melee/melee_swing_1.mp3" ),
    Sound( "lambdaplayers/weapons/l4d2/melee/melee_swing_2.mp3" )
}
local meleeHitSounds = {
    Sound( "lambdaplayers/weapons/l4d2/melee/hitsounds/zombie_blood_spray_01.mp3" ),
    Sound( "lambdaplayers/weapons/l4d2/melee/hitsounds/zombie_blood_spray_02.mp3" ),
    Sound( "lambdaplayers/weapons/l4d2/melee/hitsounds/zombie_blood_spray_03.mp3" ),
    Sound( "lambdaplayers/weapons/l4d2/melee/hitsounds/zombie_blood_spray_04.mp3" ),
    Sound( "lambdaplayers/weapons/l4d2/melee/hitsounds/zombie_blood_spray_05.mp3" ),
    Sound( "lambdaplayers/weapons/l4d2/melee/hitsounds/zombie_blood_spray_06.mp3" )
}
function LAMBDA_L4D2:SwingMeleeWeapon( lambda, weapon, target )
    local swingAnim = weapon.L4D2Data.Animation
    if swingAnim then lambda:RemoveGesture( swingAnim ); lambda:AddGesture( swingAnim ) end

    local swingSnd = weapon.L4D2Data.Sound or meleeSwingSounds
    if swingSnd != false then 
        if istable( swingSnd ) then swingSnd = swingSnd[ random( #swingSnd ) ] end
        weapon:EmitSound( swingSnd, 65, random( 96, 104 ), 1, CHAN_WEAPON ) 
    end

    local swingRate = weapon.L4D2Data.RateOfFire or 0.1
    if istable( swingRate ) then swingRate = Rand( swingRate[ 1 ], swingRate[ 2 ] ) end
    lambda.l_WeaponUseCooldown = CurTime() + swingRate

    lambda:SimpleTimer( weapon.L4D2Data.HitDelay or 0.25, function()        
        if !LambdaIsValid( target ) then return end
        local targetPos = target:WorldSpaceCenter()

        local attackSrc = lambda:GetAttachmentPoint( "eyes" ).Pos
        local attackDist = weapon.L4D2Data.Range or 70
        if attackSrc:DistToSqr( targetPos ) > ( attackDist * attackDist ) then return end

        meleeTrTbl.start = attackSrc
        meleeTrTbl.endpos = targetPos
        meleeTrTbl.filter = { lambda, wepent }
        meleeTrTbl.mask = MASK_SHOT_HULL

        local meleeTr = TraceLine( meleeTrTbl )
        if meleeTr.Fraction < 1.0 and meleeTr.Entity != target then return end

        local attackDmg = weapon.L4D2Data.Damage or 50
        if istable( attackDmg ) then attackDmg = random( attackDmg[ 1 ], attackDmg[ 2 ] ) end

        local dmginfo = DamageInfo()
        dmginfo:SetDamage( attackDmg )
        dmginfo:SetAttacker( lambda )
        dmginfo:SetInflictor( weapon )
        dmginfo:SetDamageType( weapon.L4D2Data.DamageType or DMG_SLASH )
        dmginfo:SetDamagePosition( meleeTr.HitPos )
        
        local dmgForce = weapon.L4D2Data.DamageForce or defaultDmgForce
        local dmgAng = ( meleeTr.HitPos - attackSrc ):Angle()
        dmginfo:SetDamageForce( dmgAng:Forward() * ( attackDmg * defaultDmgForce.Forward ) + dmgAng:Right() * ( attackDmg * defaultDmgForce.Right ) + dmgAng:Up() * ( attackDmg * defaultDmgForce.Up ) )

        local prevHealth = target:Health()
        target:TakeDamageInfo( dmginfo )

        if target:Health() < prevHealth then
            local bloodParticle = ents_Create( "info_particle_system" )
            bloodParticle:SetKeyValue( "effect_name", "blood_impact_red_01" )
            bloodParticle:SetPos( meleeTr.HitPos )
            bloodParticle:SetAngles( dmgAng )
            bloodParticle:SetParent( target )
            bloodParticle:Spawn()
            bloodParticle:Activate()
            bloodParticle:Fire( "Start" )
            bloodParticle:Fire( "Kill", nil, 0.4 )
        end

        local hitSound = weapon.L4D2Data.HitSound
        if hitSound then 
            if istable( hitSound ) then hitSound = hitSound[ random( #hitSound ) ] end
            weapon:EmitSound( hitSound, 70, random( 98, 102 ), 1, CHAN_WEAPON ) 
            EmitSound( meleeHitSounds[ random( #meleeHitSounds ) ], target:WorldSpaceCenter(), weapon:EntIndex(), CHAN_BODY, Rand( 0.4, 0.66 ), 60 )
        end
    end)

    return true
end

function LAMBDA_L4D2:FireWeapon( lambda, weapon, target )
    local canReload = ( weapon.L4D2Data.IsReloadable or true )
    if canReload and lambda.l_Clip <= 0 then lambda:ReloadWeapon() return true end

    local firePos = ( isvector( target ) and target or ( ( isentity( target ) and IsValid( target ) ) and target:WorldSpaceCenter() or nil ) )
    if !firePos then firePos = ( weapon:GetPos() + lambda:GetForward() ) end

    lambda.l_Clip = lambda.l_Clip - ( weapon.L4D2Data.ClipUsage or 1 )

    local fireRate = weapon.L4D2Data.RateOfFire or 0.1
    if istable( fireRate ) then fireRate = Rand( fireRate[ 1 ], fireRate[ 2 ] ) end
    lambda.l_WeaponUseCooldown = CurTime() + fireRate

    local fireAnim = weapon.L4D2Data.Animation
    if fireAnim then lambda:RemoveGesture( fireAnim ); lambda:AddGesture( fireAnim ) end

    local fireMuzzle = weapon.L4D2Data.MuzzleFlash or 1
    if fireMuzzle then lambda:HandleMuzzleFlash( fireMuzzle ) end

    local fireSnd = weapon.L4D2Data.Sound
    if fireSnd then 
        if istable( fireSnd ) then fireSnd = fireSnd[ random( #fireSnd ) ] end
        weapon:EmitSound( fireSnd, 85, random( 98, 102 ), 1, CHAN_WEAPON ) 
    end

    if IsFirstTimePredicted() then
        local fireShell = ( weapon.L4D2Data.EjectShell or "ShellEject" )
        if fireShell then
    	    local shellAttach = weapon:LookupAttachment( "shell" )
    	    if shellAttach > 0 then
    		    local shellData = weapon:GetAttachment( shellAttach )
    		    local effectData = EffectData()
    		    effectData:SetEntity( weapon )
    		    effectData:SetOrigin( shellData.Pos )
    		    effectData:SetAngles( shellData.Ang )
    		    util_Effect( fireShell, effectData )
    		end
    	end
    end

    local fireDmg = weapon.L4D2Data.Damage or 5
    if istable( fireDmg ) then fireDmg = random( fireDmg[ 1 ], fireDmg[ 2 ] ) end

    local fireSpread = weapon.L4D2Data.Spread or 0.1
    if lambda:GetCrouch() then fireSpread = fireSpread * ( weapon.L4D2Data.CrouchedSpreadScale or 0.75 ) end

    fireSpreadVec[ 1 ] = fireSpread
    fireSpreadVec[ 2 ] = fireSpread

    fireBulletTbl.Damage = fireDmg
    fireBulletTbl.Force = ( fireDmg / 3 )
    fireBulletTbl.Attacker = lambda
    fireBulletTbl.Num = ( weapon.L4D2Data.Pellets or 1 )
    fireBulletTbl.Src = weapon:GetPos()
    fireBulletTbl.Dir = ( firePos - fireBulletTbl.Src ):GetNormalized()
    fireBulletTbl.IgnoreEntity = lambda
    fireBulletTbl.Spread = fireSpreadVec
    fireBulletTbl.TracerName = "Tracer"
    weapon:FireBullets( fireBulletTbl )
end
local IsValid = IsValid
local ipairs = ipairs
local istable = istable
local isstring = isstring
local isentity = isentity
local CurTime = CurTime
local random = math.random
local Rand = math.Rand
local Effect = util.Effect
local EffectData = EffectData
local fireBulletTbl = {}
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

    if !ignoreSkins then
        local skinCount = weapon:SkinCount()
        if skinCount > 1 then weapon:SetSkin( random( 0, skinCount - 1 ) ) end
    end
end

function LAMBDA_L4D2:FireWeapon( lambda, weapon, target )
    local canReload = weapon.L4D2Data.IsReloadable or true
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
        weapon:EmitSound( fireSnd, 80, random( 98, 102 ), 1, CHAN_WEAPON ) 
    end

    local fireShell = ( weapon.L4D2Data.EjectShell or "ShellEject" )
    if fireShell then
	    local shellAttach = weapon:LookupAttachment( "shell" )
	    if shellAttach > 0 then
		    local shellData = weapon:GetAttachment( shellAttach )
		    local effectData = EffectData()
		    effectData:SetEntity( weapon )
		    effectData:SetOrigin( shellData.Pos )
		    effectData:SetAngles( shellData.Ang )
		    Effect( fireShell, effectData )
		end
	end

    local fireDmg = weapon.L4D2Data.Damage or 5
    if istable( fireDmg ) then fireDmg = random( fireDmg[ 1 ], fireDmg[ 2 ] ) end

    local fireSpread = weapon.L4D2Data.Spread or 0.1
    if lambda:GetCrouch() then fireSpread = fireSpread * ( weapon.L4D2Data.CrouchedSpreadScale or 0.66 ) end

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
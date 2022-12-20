local CurTime = CurTime
local ents_Create = ents.Create
local random = math.random
local Rand = math.Rand
local EffectData = EffectData
local util_Effect = util.Effect
local SpriteTrail = util.SpriteTrail
local BlastDamage = util.BlastDamage
local smokeColor = Color( 100, 100, 100, 125 )

local function GrenadeOnTouch( self )
    local projPos = self:GetPos()

    local effectData = EffectData()
    effectData:SetOrigin( projPos )
    effectData:SetFlags( 4 )
    util_Effect( "Explosion", effectData )

    effectData = EffectData()
    effectData:SetOrigin( projPos )
    util_Effect( "HelicopterMegaBomb", effectData )

    self:EmitSound( "lambdaplayers/weapons/l4d2/grenade_launcher/grenadefire/grenade_launcher_explode_" .. random( 1, 2 ) .. ".mp3", 140, nil, nil, CHAN_STATIC )
    
    local owner = self:GetOwner()
    local attacker = ( IsValid( owner ) and owner or self )
    local inflictor = ( IsValid( owner ) and ( IsValid( owner:GetWeaponENT() ) and owner:GetWeaponENT() or owner ) or self )
    BlastDamage( inflictor, attacker, projPos, 200, 150 )

    self:Remove()
end

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_grenade_launcher = {
        model = "models/lambdaplayers/weapons/l4d2/w_grenade_launcher.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Grenade Launcher",
        holdtype = "shotgun",
        killicon = "lambdaplayers/killicons/icon_l4d2_grenade_launcher",
        bonemerge = true,

        clip = 1,
        islethal = true,
        attackrange = 800,
        keepdistance = 500,

        reloadtime = 2.2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 1,
        reloadsounds = { 
            { 0.3, "lambdaplayers/weapons/l4d2/grenade_launcher/grenadeother/grenade_launcher_latchopen.mp3" },
            { 0.75, "lambdaplayers/weapons/l4d2/grenade_launcher/grenadeother/grenade_launcher_shellout.mp3" },
            { 1.4, "lambdaplayers/weapons/l4d2/grenade_launcher/grenadeother/grenade_launcher_shellin.mp3" },
            { 1.95, "lambdaplayers/weapons/l4d2/grenade_launcher/grenadeother/grenade_launcher_actionclosed.mp3" }
        },

        callback = function( lambda, wepent, target )
            if lambda.l_Clip <= 0 then lambda:ReloadWeapon() return true end
            
            local attachData = wepent:GetAttachment( wepent:LookupAttachment( "muzzle" ) )
            local velAng = ( ( target:GetPos() + Vector( 0, 0, lambda:GetRangeTo( target ) / 8 ) ) - attachData.Pos ):Angle()
            if lambda:GetForward():Dot( velAng:Forward() ) < 0.66 then lambda.l_WeaponUseCooldown = CurTime() + 0.1; return true end

            lambda.l_Clip = lambda.l_Clip - 1
            lambda.l_WeaponUseCooldown = CurTime() + Rand( 0.66, 0.8 )

            lambda:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW )
            lambda:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW )

            lambda:HandleMuzzleFlash( 7 )
            wepent:EmitSound( "lambdaplayers/weapons/l4d2/grenade_launcher/grenadefire/grenade_launcher_fire_1.mp3", 75, random( 98, 102 ), 1, CHAN_WEAPON )

            local proj = ents_Create( "base_anim" )
            proj:SetModel( "models/lambdaplayers/weapons/l4d2/w_grenade_launcher_projectile.mdl" )
            proj:SetPos( attachData.Pos + velAng:Forward() * 16 )
            proj:SetOwner( lambda )
            proj:Spawn()
            
            proj.Touch = GrenadeOnTouch
            proj:SetMoveType( MOVETYPE_FLYGRAVITY )
            proj:SetSolid( SOLID_BBOX )
            proj:SetAngles( velAng )
            proj:SetVelocity( velAng:Forward() * 1400 )
            SpriteTrail( proj, 0, smokeColor, true, 12, 12, 1, 0.025, "trails/smoke" )

            return true
        end
    }
} )
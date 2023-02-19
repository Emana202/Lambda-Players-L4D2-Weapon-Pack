local rofTbl = { 0.88, 1.1 }
local swingSndTbl = {
    "lambdaplayers/weapons/l4d2/melee/pitchfork/pitchfork_swing_miss1.mp3",
    "lambdaplayers/weapons/l4d2/melee/pitchfork/pitchfork_swing_miss2.mp3"
}
local dmgTbl = { 45, 55 }
local dmgForceTbl = { Forward = -75, Right = 0, Up = 0 }
local hitSndTbl = {
    "lambdaplayers/weapons/l4d2/melee/pitchfork/pitchfork_impact_flesh1.mp3",
    "lambdaplayers/weapons/l4d2/melee/pitchfork/pitchfork_impact_flesh2.mp3",
    "lambdaplayers/weapons/l4d2/melee/pitchfork/pitchfork_impact_flesh3.mp3"
}

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_melee_pitchfork = {
        model = "models/lambdaplayers/weapons/l4d2/melee/w_pitchfork.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Pitchfork",
        holdtype = "knife",
        killicon = "lambdaplayers/killicons/icon_l4d2_melee_pitchfork",
        ismelee = true,
        keepdistance = 10,
        attackrange = 85,
        bonemerge = true,
        islethal = true,

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
            wepent.L4D2Data.RateOfFire = rofTbl
            wepent.L4D2Data.Sound = swingSndTbl
            wepent.L4D2Data.HitDelay = 0.2
            wepent.L4D2Data.Range = 80
            wepent.L4D2Data.Damage = dmgTbl
            wepent.L4D2Data.DamageForce = dmgForceTbl
            wepent.L4D2Data.HitSound = hitSndTbl

            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/melee_deploy_1.mp3", 60, 100, 1, CHAN_ITEM )
        end,

        callback = function( self, wepent, target )
            LAMBDA_L4D2:SwingMeleeWeapon( self, wepent, target )
            return true
        end
    }
})
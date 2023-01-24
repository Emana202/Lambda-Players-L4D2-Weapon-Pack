local rofTbl = { 0.625, 0.675 }
local dmgTbl = { 40, 50 }
local hitSndTbl = {
    "lambdaplayers/weapons/l4d2/melee/machete/machete_impact_flesh1.mp3",
    "lambdaplayers/weapons/l4d2/melee/machete/machete_impact_flesh2.mp3"
}

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_melee_machete = {
        model = "models/lambdaplayers/weapons/l4d2/melee/w_machete.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Machete",
        holdtype = "melee",
        killicon = "lambdaplayers/killicons/icon_l4d2_melee_machete",
        ismelee = true,
        keepdistance = 10,
        attackrange = 70,
        bonemerge = true,
        islethal = true,

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
            wepent.L4D2Data.RateOfFire = rofTbl
            wepent.L4D2Data.HitDelay = 0.18
            wepent.L4D2Data.Range = 60
            wepent.L4D2Data.Damage = dmgTbl
            wepent.L4D2Data.HitSound = hitSndTbl
            
            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/melee_deploy_1.mp3", 60, 100, 1, CHAN_ITEM )
        end,

        callback = function( self, wepent, target )
            LAMBDA_L4D2:SwingMeleeWeapon( self, wepent, target )
            return true
        end
    }
})
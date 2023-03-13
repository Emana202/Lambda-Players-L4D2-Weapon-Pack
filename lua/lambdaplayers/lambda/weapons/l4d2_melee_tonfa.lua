local rofTbl = { 0.5, 0.65 }
local dmgTbl = { 30, 35 }
local hitSndTbl = {
    "lambdaplayers/weapons/l4d2/melee/tonfa/melee_tonfa_01.mp3",
    "lambdaplayers/weapons/l4d2/melee/tonfa/melee_tonfa_02.mp3"
}

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_melee_tonfa = {
        model = "models/lambdaplayers/weapons/l4d2/melee/w_tonfa.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Tonfa",
        holdtype = "melee",
        killicon = "lambdaplayers/killicons/icon_l4d2_melee_tonfa",
        ismelee = true,
        keepdistance = 10,
        attackrange = 70,
        bonemerge = true,
        islethal = true,

        OnDeploy = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
            wepent.L4D2Data.RateOfFire = rofTbl
            wepent.L4D2Data.HitDelay = 0.21
            wepent.L4D2Data.Range = 60
            wepent.L4D2Data.Damage = dmgTbl
            wepent.L4D2Data.DamageType = DMG_CLUB
            wepent.L4D2Data.HitSound = hitSndTbl

            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/melee_deploy_1.mp3", 60, 100, 1, CHAN_ITEM )
        end,

        OnAttack = function( self, wepent, target )
            LAMBDA_L4D2:SwingMeleeWeapon( self, wepent, target )
            return true
        end
    }
})
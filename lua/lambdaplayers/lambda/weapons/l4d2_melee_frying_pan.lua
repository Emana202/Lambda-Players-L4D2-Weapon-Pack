table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_melee_fryingpan = {
        model = "models/lambdaplayers/weapons/l4d2/melee/w_frying_pan.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Frying Pan",
        holdtype = "melee",
        killicon = "lambdaplayers/killicons/icon_l4d2_melee_frying_pan",
        ismelee = true,
        keepdistance = 10,
        attackrange = 70,
        bonemerge = true,
        islethal = true,

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
            wepent.L4D2Data.RateOfFire = { 0.8, 0.9 }
            wepent.L4D2Data.HitDelay = 0.21
            wepent.L4D2Data.Range = 60
            wepent.L4D2Data.Damage = { 40, 55 }
            wepent.L4D2Data.DamageType = DMG_CLUB
            wepent.L4D2Data.HitSound = {
                "lambdaplayers/weapons/l4d2/melee/pan/melee_frying_pan_01.mp3",
                "lambdaplayers/weapons/l4d2/melee/pan/melee_frying_pan_02.mp3",
                "lambdaplayers/weapons/l4d2/melee/pan/melee_frying_pan_03.mp3",
                "lambdaplayers/weapons/l4d2/melee/pan/melee_frying_pan_04.mp3"
            }

            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/melee_deploy_1.mp3", 60, 100, 1, CHAN_ITEM )
        end,

        callback = function( self, wepent, target )
            LAMBDA_L4D2:SwingMeleeWeapon( self, wepent, target )
            return true
        end
    }
})
local random = math.random

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_melee_crowbar = {
        model = "models/lambdaplayers/weapons/l4d2/melee/w_crowbar.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Crowbar",
        holdtype = "melee",
        killicon = "lambdaplayers/killicons/icon_l4d2_melee_crowbar",
        ismelee = true,
        keepdistance = 10,
        attackrange = 70,
        bonemerge = true,
        islethal = true,

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
            wepent.L4D2Data.RateOfFire = { 0.85, 1.0 }
            wepent.L4D2Data.Sound = {
                "lambdaplayers/weapons/l4d2/melee/crowbar/crowbar_swing_miss1.mp3",
                "lambdaplayers/weapons/l4d2/melee/crowbar/crowbar_swing_miss2.mp3"
            }
            wepent.L4D2Data.HitDelay = 0.225
            wepent.L4D2Data.Range = 60
            wepent.L4D2Data.Damage = { 45, 55 }
            wepent.L4D2Data.DamageType = DMG_CLUB
            wepent.L4D2Data.HitSound = {
                "lambdaplayers/weapons/l4d2/melee/crowbar/crowbar_impact_flesh1.mp3",
                "lambdaplayers/weapons/l4d2/melee/crowbar/crowbar_impact_flesh2.mp3"
            }

            if random( 1, 10 ) == 1 then wepent:SetSkin( 1 ) end
            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/melee_deploy_1.mp3", 60, 100, 1, CHAN_ITEM )
        end,

        callback = function( self, wepent, target )
            LAMBDA_L4D2:SwingMeleeWeapon( self, wepent, target )
            return true
        end
    }
})
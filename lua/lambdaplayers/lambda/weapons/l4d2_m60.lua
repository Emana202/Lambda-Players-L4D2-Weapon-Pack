local net = net
local FrameTime = FrameTime

local fireDamageTbl = { 25, 28 }

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_m60 = {
        model = "models/lambdaplayers/weapons/l4d2/w_m60.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "M60",
        holdtype = "shotgun",
        killicon = "lambdaplayers/killicons/icon_l4d2_m60",
        bonemerge = true,

        clip = 150,
        islethal = true,
        attackrange = 1500,
        keepdistance = 400,

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Damage = fireDamageTbl
            wepent.L4D2Data.Spread = 0.133
            wepent.L4D2Data.Sound = "lambdaplayers/weapons/l4d2/m60/gunfire/machinegun_fire_1.mp3"
            wepent.L4D2Data.RateOfFire = 0.11
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
            wepent.L4D2Data.EjectShell = "RifleShellEject"
            wepent.L4D2Data.MuzzleFlash = 7
            wepent.L4D2Data.IsReloadable = false
            wepent.L4D2Data.DeploySound = "lambdaplayers/weapons/l4d2/m60/gunother/rifle_deploy_1.mp3"

            LAMBDA_L4D2:InitializeWeapon( self, wepent )
            
            local oldReload = self.ReloadWeapon
            function self:ReloadWeapon()
                if self:GetWeaponName() == "l4d2_m60" then return end
                oldReload( self )
            end
        end,

        callback = function( self, wepent, target )
            LAMBDA_L4D2:FireWeapon( self, wepent, target )

            if self.l_Clip <= 0 then 
                self:SimpleTimer( FrameTime(), function() 
                    net.Start( "lambdaplayers_createclientsidedroppedweapon" )
                        net.WriteEntity( wepent )
                        net.WriteVector( self:GetForward() * 3000 + self:GetUp() * 2500 )
                        net.WriteVector( wepent:GetPos() )
                        net.WriteVector( self:GetPhysColor() )
                        net.WriteString( "l4d2_m60" )
                    net.Broadcast()    
                end )

                self:SimpleTimer( FrameTime() * 2, function() self:SwitchToRandomWeapon() end )
            end

            return true
        end
    }
} )
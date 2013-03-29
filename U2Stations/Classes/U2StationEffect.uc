/*
 * Copyright (c) 2010, 2013 Dainius "GreatEmerald" Masiliūnas
 * 
 * This file is part of Unreal II/XMP Weapons Mutator Pack for UT2004.
 * 
 * You can redistribute the Unreal II/XMP Weapons Mutator Pack for 
 * UT2004 and/or modify it under the terms of the GNU Lesser General 
 * Public License as published by the Free Software Foundation, either 
 * version 3 of the License, or (at your option) any later version, 
 * with the exception that the code cannot be commercially exploited in 
 * any way without prior consent of Epic Games.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
//-----------------------------------------------------------
// U2StationEffect.uc
// Base particle effect for all stations. Recreated from U2XMP.
// GreatEmerald, 2010
//-----------------------------------------------------------
class U2StationEffect extends Emitter;

DefaultProperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=True
        FadeIn=True
        UniformSize=True
        Acceleration=(Z=6.960000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.000000,Max=0.000000))
        FadeOutStartTime=3.000000
        FadeInEndTime=1.000000
        MaxParticles=20
        Name="SpriteEmitter0"
        StartLocationRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Min=-25.000000,Max=-25.000000))
        StartSizeRange=(X=(Min=1.500000,Max=1.500000),Y=(Min=1.500000,Max=1.500000),Z=(Min=1.500000,Max=1.500000))
        InitialParticlesPerSecond=100.000000
        Texture=Texture'U2StationsT.Stations.PlayerIcon_Medic_TD_01'
        StartVelocityRange=(Z=(Min=2.500000,Max=2.500000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(Y=(Min=0.700000,Max=0.700000),Z=(Min=0.000000,Max=0.000000))
        Opacity=0.500000
        MaxParticles=1
        Name="SpriteEmitter1"
        StartLocationRange=(X=(Min=35.000000,Max=35.000000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=15.000000,Max=15.000000),Z=(Min=15.000000,Max=15.000000))
        InitialParticlesPerSecond=100.000000
        Texture=Texture'U2StationsT.Stations.Icon_Medical_TD_001'
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    AutoDestroy=True
    bNoDelete=False
}

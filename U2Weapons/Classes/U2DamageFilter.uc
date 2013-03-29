/*
 * Copyright (c) 2013 Dainius "GreatEmerald" Masiliūnas
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
// XMPDamageFilter.uc
// 2004 jasonyu
// 12 July 2004
//-----------------------------------------------------------

class U2DamageFilter extends Info
	abstract;

const MaxFilteredDamageTypes = 12;

struct STRUCT_DamageFilter
{
	var class<DamageType> DamageType;
	var float DamageMultiplier;
	var float MomentumMultiplier;
};

var STRUCT_DamageFilter Filter[MaxFilteredDamageTypes];

/*
!!mdf-tbd: couple of ideas:

#1

Allow optionally instanced DamageFilter to support NPCs etc. modifying
their damage filter dynamically -- e.g. shoot NPC, damage it initially
but it "adapts" and after a while no longer hurt by that type of damage (alternatively,
could just support multiple static filters which are swapped-in but this
wouldn't be as flexible. Could be very cool for boss creatures. Just
add support for instances of DamageFilter (MyDamageFilter) and support
for adding/removing/modifying entries.

#2

Allow damage filter to modify DamageType also (make this an "out" parameter).
e.g. say, shian might react to leeches as though they are burning rather than
causing biological damage.
*/

/*NEW 2002.07.15 PWC
	Added optional out parameter DamageFloat because precision was being lost by using int
	I didn't want to break anyone else's code so I just added an extra parameter which can
	be used if necessary
*/
static function ApplyFilter( out int Damage, out vector Momentum, class<DamageType> DamageType, optional out float DamageFloat )
{
	local int i;
	local float InDamage,DamageMultiplier;
	InDamage = Damage;

	for( i = 0; i < ArrayCount(default.Filter) && default.Filter[i].DamageType != None; i++ )
	{
		if( ClassIsChildOf( DamageType, default.Filter[i].DamageType ) )
		{
			DamageMultiplier = default.Filter[i].DamageMultiplier;
			DamageFloat	*= DamageMultiplier;
			Damage		*= DamageMultiplier;
			Momentum	*= default.Filter[i].MomentumMultiplier;

			// Account for small damages that round to zero.
			if(Damage == 0)
			{
				InDamage *= DamageMultiplier;
				if((InDamage > 0) && (FRand() < InDamage))
					Damage = 1;
			}

			return;
		}
	}
}

defaultproperties
{
}

script "crapshot.ash";
since r18892;

import <crapshot/_types>
import <crapshot/_utils>
import <crapshot/arcade>
import <crapshot/consumption>
import <crapshot/coolitems>
import <crapshot/demonnames>
import <crapshot/discoveries>
import <crapshot/familiars>
import <crapshot/hobocodes>
import <crapshot/karma>
import <crapshot/manuel>
import <crapshot/mritems>
import <crapshot/skills>
import <crapshot/tattoos>
import <crapshot/tracked>
import <crapshot/trophies>

#	This is a fork of cheesecookie's fork of bumcheekcity's snapshot script.
#	Code comes straight from that. Relay layout is copied from cheesecookie's website layout which is copied from bumcheekcity's.
#	Things are then hacked onto it in order to increase support. Beep beep. Boop boop.

Result generate_snapshot() {
	Result r;

	print("Checking skills...", "olive");
	r.skills = generateSkillsSnapshot();

	print("Checking tattoos...", "olive");
	r.tattoos = generateTattoosSnapshot();

	print("Checking trophies...", "olive");
	r.trophies = generateTrophiesSnapshot();

	print("Checking familiars...", "olive");
	r.familiars = generateFamiliarsSnapshot();

	print("Checking hobo codes...", "olive");
	r.hobocodes = generateHoboCodesSnapshot();

	print("Checking for Telescope", "olive");
	r.telescope = get_property("telescopeUpgrades").to_int();

	print("Checking for Mafia Tracked Data", "olive");
	r.tracked = generateTrackedSnapshot();

	print("Checking for Discoveries", "olive");
	r.discoveries = generateDiscoveriesSnapshot();

	print("Checking for Mr. Items", "olive");
	r.mritems = generateMrItemsSnapshot();

	print("Checking for Cool Items", "olive");
	r.coolitems = generateCoolItemsSnapshot();

	print("Checking for Consumed Food", "olive");
	r.consumption = generateConsumptionSnapshot();

	print("Checking for Rogue Program Stuff", "olive");
	r.arcade = generateArcadeSnapshot();

	print("Checking Demon Names", "olive");
	r.demonnames = generateDemonNamesSnapshot();

	print("Checking Karma", "olive");
	r.karma = generateKarmaSnapshot();

	print("Checking simplified Manuel data", "olive");
	r.manuel = generateManuelSnapshot();

	r.inrun = !get_property("kingLiberated").to_boolean();
	r.version = svn_info("crapshot").last_changed_rev;
	r.timestamp = now_to_string("yyyy-MM-dd'T'HH:mm:ss.SSSX");

	return r;
}

void main()
{
	if(!get_property("kingLiberated").to_boolean())
	{
		if(!user_confirm("This script should not be run while you are in-run. It may blank out some of your skills, telescope, bookshelf or some other aspect of your profile until you next run it in aftercore. Are you sure you want to run it (not recommended)?", 15000, false))
		{
			abort("User aborted. Beep");
		}
	}

	confirmElementalPlanes();

	Result r = generate_snapshot();
	print(r.to_json());
}

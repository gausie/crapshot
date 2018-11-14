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

string generate_snapshot() {
	string r =
		generateSkillsSnapshot() + "&" +
		generateTattoosSnapshot() + "&" +
		generateTrophiesSnapshot() + "&" +
		generateFamiliarsSnapshot() + "&" +
		generateHoboCodesSnapshot() + "&" +
		generateTrackedSnapshot() + "&" +
		generateDiscoveriesSnapshot() + "&" +
		generateMrItemsSnapshot() + "&" +
		generateCoolItemsSnapshot() + "&" +
		generateConsumptionSnapshot() + "&" +
		generateArcadeSnapshot() + "&" +
		generateDemonNamesSnapshot() + "&" +
		generateKarmaSnapshot() + "&" +
		generateManuelSnapshot() + "&" +
		"inrun=" + !get_property("kingLiberated").to_boolean() + "&" +
		"version=" + svn_info("crapshot").last_changed_rev + "&" +
		"timestamp=" + now_to_string("yyyy-MM-dd'T'HH:mm:ss.SSSX");

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

	string r = generate_snapshot();
	print(r);
}

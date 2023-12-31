import <zlib.ash>
boolean[string] available_choices;
void main(string settings) {
	// task keywords
	foreach task in $strings[
		coffee,
		ascend,
		gyou,
		cs,
		lunch,
		smoke
	] available_choices[task] = false;
	// abbreviations
	string[string] abbreviations = {
		# "all": "coffee ascend gyou cs lunch smoke",
		"post" :"lunch smoke",
		"gloop":"coffee ascend gyou lunch smoke",
		"cloop":"coffee ascend cs smoke",
		"crash":"cs smoke"
	};
	// parse settings
	foreach i,key in settings.to_lower_case().split_string(" ") {
		if (abbreviations contains key) {
			print(`Running choice {key}!`, "teal");
			foreach i,task in abbreviations[key].split_string(" ")
				available_choices[task] = true;
		}
		else if (available_choices contains key) {
			print(`Running choice {key}!`, "teal");
			available_choices[key] = true;
		}
	}
	// selected tasks run in this order:
	foreach task in $strings[coffee, ascend, gyou, cs, lunch, smoke]
		if (available_choices[task])
			call void task();
}

void HandleC2T() {
	//If you use c2t to handle your ascensions for cs. MAKE SURE TO CHECK THE 2ND STRING to make sure it picks the correct class and astral items.
	if (available_choices["gyou"]) {
		set_property("c2t_ascend", "2,27,2,44,8,5046,5039,2,0");
	}
	if (available_choices["cs"]) {
		set_property("c2t_ascend", "2,1,2,25,4,5046,5035,2,0");#####  2,3,2,25,2,5046,5035,2,0  #####
	}														   #####       Settings for PM      #####
}

void getBofaWish() {
		if(get_property("_bookOfFactsWishes").to_int() < 3) {
			print("Getting the Bofa pocket wishes!", "teal");
			switch(my_class()) {
				case $class[Seal Clubber]:
					maximize("familiar weight, .1 item drop -equip broken champagne bottle", false);
					use_familiar($familiar[Pair of Stomping Boots]);
					cli_execute("kolfix auto");
					while(get_property("_bookOfFactsWishes").to_int() < 3) {
						adv1($location[Shadow Rift (Forest Village)], 1, "if monstername shadow guy || monstername shadow spider; runaway; abort; endif; attack;");
					}
				break;
				case $class[Pastamancer]:
					use_familiar($familiar[Patriotic Eagle]);
					maximize("item drop, -equip broken champagne bottle", false);
					use_skill(1, $skill[map the monsters]);
					visit_url("adventure.php?snarfblat=354");
					visit_url("choice.php?forceoption=0&option=1&pwd&whichchoice=1435&heyscriptswhatsupwinkwink=12");
					run_combat("skill 7450; skill Saucegeyser; repeat");
					use_familiar($familiar[Pocket Professor]);
					adv1($location[The Degrassi Knoll Garage], 1, "attack; repeat");
					adv1($location[The Degrassi Knoll Garage], 1, "attack; repeat");
				break;
			}
		}
}

boolean unlockGuild() {
	int internalQuestStatus(string prop) {
	string status = get_property(prop);
	if(status == "unstarted") {
		return -1;
	}
	if(status == "started") {
		return 0;
	}
	if(status == "finished") {
		//Does not handle quests with over 9998 steps. That\'s the Gnome letter quest, yes?
		return 9999;
	}
	matcher my_element = create_matcher("step(\\d+)", status);
	if(my_element.find()) {
		return to_int(my_element.group(1));
	}
	return -1;
	}
	string pref;
	location loc = $location[None];
	item goal = $item[none];
	use_familiar($familiar[Pair of Stomping Boots]);
	maximize("+com, .1 familiar weight", false);
	switch(my_primestat()) {
		case $stat[Muscle]:
			pref = "questG09Muscle";
			loc = $location[The Outskirts of Cobb\'s Knob];
			goal = $item[11-Inch Knob Sausage];
			break;
		case $stat[Mysticality]:
			pref = "questG07Myst";
			loc = $location[The Haunted Pantry];
			goal = $item[Exorcised Sandwich];
			break;
		case $stat[Moxie]:
			goal = equipped_item($slot[pants]);
			pref = "questG08Moxie";
			if(internalQuestStatus(pref) < 1) {
				loc = $location[The Sleazy Back Alley];
			}
			break;
	}
	if(loc != $location[none]) {
		if(get_property(pref) != "started") {
			string temp = visit_url("guild.php?place=challenge");
		}
		if(internalQuestStatus(pref) < 0) {
			print("Visiting the guild failed to set guild quest.", "red");
			return false;
		}
		while(item_amount(goal) != 1) {
			adv1(loc, -1, "runaway; abort");
		}
		if (internalQuestStatus(pref) == 1) {
			//Complete quest then spam visit a couple nerds to unlock degrassi gnoll and distant woods
			visit_url("guild.php?place=challenge");
			visit_url("guild.php?place=paco");
			visit_url("guild.php?place=paco");
			visit_url("guild.php?place=paco");
			visit_url("choice.php?pwd&whichchoice=930&option=2");
			visit_url("guild.php?place=scg");
			visit_url("guild.php?place=scg");
		}
		return true;
	}
	return false;
}

void yachtzee() {
	if(get_property("ascensionsToday").to_int() == 1 && my_inebriety() > inebriety_limit()) {
		print("we're overdrunk, and have ascended today. No more garb'ing!", "red");
	}else if(my_adventures() == 0 && my_inebriety() > inebriety_limit()) {
		print("We're overdrunk, and have used all our turns. This leg is finished. Moving on to ascending.", "red");
		}else if (my_inebriety() > inebriety_limit()) {
			print("We're overdrunk. Running Garbo overdrunk turns.", "blue");
			cli_execute("garbo ascend");
			}else if(get_property("ascensionsToday").to_int() == 1) {
					print("We have already ascended today. Running noflags garbo.", "blue");
					cli_execute("garbo");
				}else {
					print("We have not ascended today. Rest in Peace Yachtzee. I hardly knew you.", "blue");
					//Basically, this is if we are a seal clubber
						cli_execute("garbo ascend workshed=cmc -5");
						getBofaWish();
					}
				cli_execute("shrug ur-kel");
				cli_execute("drink stillsuit distillate");
				cli_execute("CONSUME NIGHTCAP");
}	

void buyTix() {
		//Buy as many day passes as bux allow
	if (get_property("_stenchAirportToday").to_boolean()) {
		buy($coinmaster[The Dinsey Company Store], floor((item_amount($item[Funfunds&trade;]) / 20)), $item[One-day ticket to dinseylandfill]);
	}
	if (get_property("_sleazeAirportToday").to_boolean()) {
		buy($coinmaster[Buff Jimmy's Souvenir Shop], floor((item_amount($item[Beach Buck]) / 100)), $item[One-day ticket to Spring Break Beach]);
	}
}

void randFam() {
	//take out a random familiar that can equip RO gear so all fam's can get some love!
    familiar[int] my_familiars;
    int have = 0;
    foreach it in $familiars[] {
        if (have_familiar(it) && can_equip(it) && can_equip(it, $item[solid shifting time weirdness])) {
            my_familiars[have] = it;
            have += 1;
        }
    }
    use_familiar(my_familiars[random(have)]);
}

void clipArt() {
	item it = $item[box of Familiar Jacks];
	print(`Casting clip art for item {it}! Tired of being clubbed by mall value!`, "teal");
	retrieve_item(it, 3 - get_property("_clipartSummons").to_int() + available_amount(it));
}

void coffee() {
	print("Doing start-of-day activities!", "teal");
	if(!get_property("_coffeeBegin").to_boolean()){
		cli_execute("ptrack add coffeeBegin");
		//cli_execute("git update; svn update");//force update all the scripts
		if(my_class() == $class[Pastamancer]) {//Increment Map the monsters by 1 so garbo saves us a cast
			set_property("_monstersMapped", "1");
		}
		set_property("_coffeeBegin", "true");
	}
	if(!to_boolean(get_property("breakfastCompleted"))){
		cli_execute("breakfast");
		cli_execute("/whitelist cgc");
		cli_execute("acquire carpe");
		clipArt();
	}
	if (!get_property("_essentialTofuUsed").to_boolean()) {
		print("Tofu unused! Trying to buy some!", "teal");
		buy(1, $item[essential tofu], get_property("valueOfAdventure").to_int() * 4);
		if (item_amount($item[essential tofu]) > 0) {
			use(1, $item[Essential Tofu]);
		}
		else {
			print("Tofu is more expensive than would be vialble. Skipping Tofu.");
		}
	} // FYI: Garbo usually doesn't use one of these, so free 5 adventures. Yay!
	if(!get_property("_garbOneDone").to_boolean()) {
		yachtzee();
		set_property("_garbOneDone", "true");
	}
	if(get_property("_garbOneDone").to_boolean()) {
		yachtzee();
		buyTix();
	}
	if(get_property("_augSkillsCAst").to_int() < 5) {
		print("Garbo didn't cast all of the scepter skills. Burning remaining casts.", "red");
		foreach sk in $skills[7454, 7455, 7456, 7475, 7476, 7477, 7480, 7482] {
			use_skill(sk);
		}
	}
}

void ascend() {
	if(my_inebriety() <= inebriety_limit()) {
		abort("You have not nightcapped yet! Overdrink and burn turns, then run again!");
	}else if(my_inebriety() > inebriety_limit() && my_adventures() > 0) {
		abort("You have nightcapped, but have turns remaining! Burn turns, then run again!");
	}
	foreach it in $items[calzone of legend, deep dish of legend, pizza of legend] {
		if(item_amount(it) < 1) {
			print(`Crafting 1 {it}`);
			cli_execute(`make {it}`);
		}
	}
	if(visit_url("campground.php?action=workshed",false,true).contains_text('value="Save Train Set Configuration"')){
    	// all stat -> coal -> mus -> meat -> mp -> ore -> ml -> hotres
    	// [  WE ONLY HIT THESE  ]   [       THESE DO NOT MATTER      ]
    	visit_url("choice.php?pwd&whichchoice=1485&option=1&slot[0]=3&slot[1]=8&slot[2]=17&slot[3]=1&slot[4]=2&slot[5]=20&slot[6]=19&slot[7]=4",true,true);
    	cli_execute("refresh all");
	}
	print("Jumping through the Gash!", "teal");
	HandleC2T();
	wait(5);
	cli_execute("c2t_ascend"); //c2t call to ascend. Change settings via the relay page.
	visit_url("choice.php"); //think I still need to click thru the choice adv
	run_choice(1);
}

void gyou() {
	print("Running gyou!", "teal");
	if(!get_property("_gyouBegin").to_boolean()){
		cli_execute("ptrack add gyouBegin");
		set_property("_gyouBegin", "true");
	}
	cli_execute("loopgyou");
	if (my_adventures() >= 41) {
		cli_execute("PandAliisza 40");//call using 40 as arg. Should execute script but stop when advs remaining is == 40
	}
	print("Breaking the Prism in t-10 seconds", "teal");
	waitq(16);
	visit_url("place.php?whichplace=nstower&action=ns_11_prism");
	visit_url("main.php");
	run_choice(1); //Change number to pick class. 1=SC; 2=TT; 3=PM; 4=SA; 5=DB; 6=AT
	visit_url("main.php");
}

void cs() {
	print("Running CS!", "teal");
	if(!get_property("_csBegin").to_boolean()) {
		cli_execute("ptrack add csBegin");
		set_property("_csBegin", "true");
	}
	if(my_path() == $path[Community Service]) {
		cli_execute("lcswrapper");
	}
	use($item[Asdon Martin keyfob]);
	visit_url(`uneffect.php?using=Yep.&pwd&whicheffect={$effect[Citizen of a Zone].id}`);//try uneffecting madness bakery eagle buff so garbo gets meat
	if(item_amount($item[bitchin' Meatcar]) < 1 && item_amount($item[Desert Bus pass]) < 1){
    	cli_execute("make bitchin' meatcar");
  	}
	if(get_property("questG09Muscle") != "finished" || get_property("questG07Myst") != "finished" || get_property("questG08Moxie") != "finished") {
		unlockGuild();
	}
	if(my_class() == $class[Seal Clubber]) {
		cli_execute("kolfix auto");
		getBofaWish();
	}
		//tuning to wombat
	if ((!get_property('moonTuned').to_boolean()) && (my_sign() != "Wombat") && (available_amount($item[Hewn moon-rune spoon]).to_boolean()) ) {
		foreach sl in $slots[acc1, acc2, acc3] {
			if (equipped_item(sl) == $item[Hewn moon-rune spoon]) {
				equip(sl, $item[none]);
			}
		}
		visit_url("inv_use.php?whichitem=10254&doit=96&whichsign=7");
	}
}

void lunch() {
	print("Having a bite and leveling up!", "teal");
	cli_execute("hagnk all");
	if(!get_property("_lunchBegin").to_boolean()){
		cli_execute("ptrack add lunchBegin");
		set_property("_lunchBegin", "true");
		cli_execute("/whitelist cgc");
		cli_execute("acquire carpe");  //This is here becasue sometimes buffy be slow.	
	}
	if(my_level() < 13){
		cli_execute("levelup");
	}
	if(!have_skill($skill[Liver of Steel])){
		cli_execute("PandAliisza 5");//call using random low number of adventures remaining, but more than 0 for testing
	}
	if(item_amount($item[steel margarita]) > 0) {
		drink($item[Steel margarita]);
	}
	use($item[Asdon Martin keyfob]);
	//janky handling of using shotglass to make use of the +5 turns from blender before swapping to Wombat.
	if (!to_boolean(get_property("_mimeArmyShotglassUsed"))) {
		print("We have not used shotglass yet.");
		if (item_amount($item[astral six-pack]) > 0) {
			use($item[astral six-pack]);
		}
		drink(1, $item[astral pilsner]);
	}
	else {
		print("We already used our shotglass...somehow. Big sad!");
	}
	//tuning to wombat
	if ((!get_property('moonTuned').to_boolean()) && (my_sign() != "Wombat") && (available_amount($item[Hewn moon-rune spoon]).to_boolean()) ) {
		foreach sl in $slots[acc1, acc2, acc3] {
			if (equipped_item(sl) == $item[Hewn moon-rune spoon]) {
				equip(sl, $item[none]);
			}
		}
		visit_url("inv_use.php?whichitem=10254&doit=96&whichsign=7");
	}
	//monkey paw wishes cause garbo does silly things in post gyou leg
	visit_url("main.php?action=cmonk&pwd");
	foreach str in $strings["Frosty", "Sinuses for Miles", "Braaaaaains", "Frosty", "Sinuses for Miles"] {
		run_choice(1, `wish=${str}`);
	}
	visit_url("main.php");
}

void smoke() {
	print("Running garbo and ending the day off!", "teal");
	if(!get_property("_smokeBegin").to_boolean()){
		cli_execute("ptrack add smokeBegin");
		set_property("_smokeBegin", "true");
	}
	print("Stashing most of our meat for safe keeping, and anti-heckup!", "green");
	put_closet(max(0, my_meat() - 10000000)); //Stash all but 10mil meat while saving up big numbers
	//max function returns whichever is higher. So in the case of less than 10mil, 0 is returned and nothing is closeted
	if(!to_boolean(get_property("breakfastCompleted"))){
		cli_execute("breakfast");
		cli_execute("/whitelist cgc");
		clipArt();
	}
	if (!to_boolean(get_property("_floundryItemCreated"))) {
		cli_execute("acquire carpe");
	}
	if (!get_property("_essentialTofuUsed").to_boolean()) {
		print("Tofu unused! Trying to buy some!", "teal");
		cli_execute(`buy essential tofu @{(get_property("valueOfAdventure").to_int() * 4)}`);
		if (item_amount($item[essential tofu]) > 0) {
				use(1, $item[Essential Tofu]);
		}else{
			print("Tofu is more expensive than would be vialble. Skipping Tofu.");
		}
	} //FYI: Garbo usually doesn't use one of these, so free 5 adventures. Yay!
	yachtzee();
	buyTix();
	if(my_adventures() == 0) {
		cli_execute("shrug ur-kel");
		cli_execute("CONSUME NIGHTCAP");
		retrieve_item(1, $item[Burning cape]);
		if(get_property("_augSkillsCast") < 5) {
			print("Casting Off-hand Remarkable", "green");
			use_skill($skill[7464]);//Left/Off handers day
		}
	}
	if (item_amount($item[clockwork maid]) > 0 && !get_property("haveMaid").to_boolean() || buy(1, $item[clockwork maid], get_property("valueOfAdventure").to_int() * 8) > 0)  {
    		use(1, $item[clockwork maid]);
			set_property("haveMaid", "true");
	}// Refrains from using a clockwork maid if you it's lower then 8x VOA 
	if(item_amount($item[Burning cape]) > 0) {
		cli_execute("rollover management.ash");
		//Maximize string that prioritizes adventures, and values sasq watch for the meat buff
		randFam();
		maximize(`{get_property("valueOfAdventure")} adventures, 15000 bonus ¶7776, +equip ratskin pajama pants, +equip spacegate scientists insignia`, false);
		cli_execute("ptrack add smokeEnd");
		cli_execute("mallbuy 9999 surprisingly capacious handbag @ 120");
		cli_execute("mallbuy 9999 fireclutch @ 650");
		cli_execute("pTrack recap");
	}
	if (item_amount($item[navel ring of navel gazing]) > 0) {
		print("Returning ring to Noob.");
		kmail("Noobsauce", "Returning your ring.", 0, int[item] {$item[navel ring of navel gazing] : 1});
	}
	if(item_amount($item[raffle ticket]) == 0) {
		cli_execute("raffle 11");
	}
	print("Done!", "teal");
	print("Check for the free August Scepter skill.", "teal");
}
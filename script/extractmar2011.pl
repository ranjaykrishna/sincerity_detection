#!/usr/bin/perl
#   extract lexical features from  speed dates
#   Dan Jurafsky

   @hedgepatterns = (
    'I guess[a-z-]*[^a-z]',
     'I think[a-z-]*[^a-z]',
      'maybe[^a-z]',
       'possibly[^a-z]',
        'probably[^a-z]',
	 'sort of[^a-z]',
	  'kind of[^a-z]',
	     'a little[^a-z]',
	      'A little[^a-z]');

   @lovepatterns = (
' love[^a-z]',
' loved[^a-z]',
' loving[^a-z]',
' passion[^a-z]',
' passions[^a-z]',
' passionate[^a-z]',);

   @hatepatterns = ('hate[^a-z]');
   @sexpatterns = (
' sex[^a-z]',
' sexual[^a-z]',
' lover[^a-z]',
' lovers[^a-z]',
' sexy[^a-z]',
' stripper[^a-z]',
' kissed[^a-z]',
' kissing[^a-z]',
' kiss me[^a-z]',
'Eskimo kisses[^a-z]',);

   @workpatterns = (
 ' academia[^a-z]',
 ' teacher[^a-z]',
 ' technology[^a-z]',
 ' teaching[^a-z]',
 ' teach[^a-z]',
 ' teachers[^a-z]',
 ' research[^a-z]',
 ' management[^a-z]',
 ' taught[^a-z]',
 ' organization[^a-z]',
 ' companies[^a-z]',
 ' policy[^a-z]',
 ' faculty[^a-z]',
 ' center[^a-z]',
 ' lab[^a-z]',
 ' position[^a-z]',
 ' competitive[^a-z]',
 ' professor[^a-z]',
 ' professors[^a-z]',
 ' interview[^a-z]',
 ' advisor[^a-z]',
 ' funding[^a-z]',
 ' Ph\.D\.',
 ' PhD\.',
 ' PhD',
 ' PHD',
 ' masters[^a-z]',
 ' Masters[^a-z]',
 ' Master\'s[^a-z]',
 ' class[^a-z]',
 ' classes[^a-z]',
 ' department[^a-z]',
 ' Department[^a-z]',
 ' graduate[^a-z]',
 ' grad[^a-z]',
 ' study[^a-z]',
 ' program[^a-z]',
 ' worked[^a-z]',
 ' working[^a-z]',
 ' work[^a-z]',
 ' degree[^a-z]',
 ' finish[^a-z]',
 ' finishing[^a-z]'
);

@drinkpatterns = (
' alcohol[a-z-]*[^a-z]',
' bar[^a-z]',
' happy hour',
' bars[^a-z]',
' party[^a-z]',
' beer[a-z-]*[^a-z]',
' booz[a-z-]*[^a-z]',
' cocktail[a-z-]*[^a-z]',
' whiskey[a-z-]*[^a-z]',
' whisky[a-z-]*[^a-z]',
' wine[^a-z]',
' wines[^a-z]',
' drank[^a-z]',
' drink[a-z-]*[^a-z]',
' drunk[a-z-]*[^a-z]',
' liquor[a-z-]*[^a-z]'
);

@foodpatterns = (
' anorexi[a-z-]*[^a-z]',
' appeti[a-z-]*[^a-z]',
' ate[^a-z]',
' bake[a-z-]*[^a-z]',
' baking[^a-z]',
' binge[a-z-]*[^a-z]',
' binging[^a-z]',
' boil[a-z-]*[^a-z]',
' bread[^a-z]',
' breakfast[a-z-]*[^a-z]',
' brunch[a-z-]*[^a-z]',
' bulimi[a-z-]*[^a-z]',
' cafeteria[a-z-]*[^a-z]',
' candie[a-z-]*[^a-z]',
' candy[^a-z]',
' chow[a-z-]*[^a-z]',
' coffee[a-z-]*[^a-z]',
' coke[a-z-]*[^a-z]',
' cook[a-z-]*[^a-z]',
' dessert[a-z-]*[^a-z]',
' to digest[^a-z]',
' dine[^a-z]',
' dined[^a-z]',
' diner[^a-z]',
' diners[^a-z]',
' dines[^a-z]',
' dining[^a-z]',
' dinner[a-z-]*[^a-z]',
' dishes[^a-z]',
' eat[^a-z]',
' eaten[^a-z]',
' eating[^a-z]',
' eats[^a-z]',
' eggs[^a-z]',
' espresso[a-z-]*[^a-z]',
' feed[^a-z]',
' feeder[a-z-]*[^a-z]',
' feeds[^a-z]',
' food[a-z-]*[^a-z]',
' fries[^a-z]',
' fry[a-z-]*[^a-z]',
' glutton[a-z-]*[^a-z]',
' gobble[a-z-]*[^a-z]',
' gobbling[^a-z]',
' grocer[a-z-]*[^a-z]',
' gulp[a-z-]*[^a-z]',
' helpings[^a-z]',
' hunger[a-z-]*[^a-z]',
' hungr[a-z-]*[^a-z]',
' ingest[a-z-]*[^a-z]',
' kitchen[a-z-]*[^a-z]',
' lunch[a-z-]*[^a-z]',
' meal[a-z-]*[^a-z]',
' overate[^a-z]',
' overeat[a-z-]*[^a-z]',
' overweight[^a-z]',
' pasta[a-z-]*[^a-z]',
' pizza[a-z-]*[^a-z]',
' restau[a-z-]*[^a-z]',
' salad[a-z-]*[^a-z]',
' sandwich[a-z-]*[^a-z]',
' servings[^a-z]',
' snack[a-z-]*[^a-z]',
' soda[a-z-]*[^a-z]',
' stuffed[^a-z]',
' sugar[a-z-]*[^a-z]',
' supper[a-z-]*[^a-z]',
' swallow[a-z-]*[^a-z]',
' tea[^a-z]',
' thirst[a-z-]*[^a-z]',
' veget[a-z-]*[^a-z]',
' veggie[a-z-]*[^a-z]',
' tortilla[a-z-]*[^a-z]',
' taco[a-z-]*[^a-z]',
' bacon[a-z-]*[^a-z]',
' donut[a-z-]*[^a-z]',
' scallop[a-z-]*[^a-z]',
' bread[a-z-]*[^a-z]',
' quiche[a-z-]*[^a-z]',
' pastry[a-z-]*[^a-z]',
' recipe[a-z-]*[^a-z]',
' grilled[a-z-]*[^a-z]',
' oven[a-z-]*[^a-z]',
' pasta[a-z-]*[^a-z]',
' sauce[a-z-]*[^a-z]',
' butter[a-z-]*[^a-z]',
' cheese[a-z-]*[^a-z]',
' cream[a-z-]*[^a-z]',
' coconut[a-z-]*[^a-z]',
' mushroom[a-z-]*[^a-z]',
' watercress[a-z-]*[^a-z]',
' lamb[a-z-]*[^a-z]',
' walnut[a-z-]*[^a-z]',
' maple[a-z-]*[^a-z]',
' cake[a-z-]*[^a-z]',
' cheesecake[a-z-]*[^a-z]',
' chocolate[a-z-]*[^a-z]',
' strawberr[a-z-]*[^a-z]',
' apple[a-z-]*[^a-z]',
' pineapple[a-z-]*[^a-z]',
' grape[a-z-]*[^a-z]',
' pork[a-z-]*[^a-z]',
' banana[a-z-]*[^a-z]',
' chicken[a-z-]*[^a-z]',
' rice[^a-z]',
' sushi[^a-z]',
' chili[^a-z]',
' couscous[^a-z]',
' [Gg]raham[^a-z]',
' [Oo]reo[^a-z]',
' chewing some',
' every dish',
' favorite dish',
' best dish',
' nice dish',
' any dishes',
' taste good',
' tastes like',
' can taste',
' tasty',
' I.m chewing',
' Hershey',
' bean[a-z-]*[^a-z]',
' burrito[a-z-]*[^a-z]',
' barbecue[a-z-]*[^a-z]'
);

   @negemopatterns = (
 ' abandon[a-z-]*[^a-z]',
 ' enrag[a-z-]*[^a-z]',
 ' maddening[^a-z]',
 ' snob[a-z-]*[^a-z]',
 ' abuse[a-z-]*[^a-z]',
 ' envie[a-z-]*[^a-z]',
 ' madder[^a-z]',
 ' sob[^a-z]',
 ' abusi[a-z-]*[^a-z]',
 ' envious[^a-z]',
  ' maddest[^a-z]',
  ' sobbed[^a-z]',
  ' ache[a-z-]*[^a-z]',
  ' envy[a-z-]*[^a-z]',
  ' maniac[a-z-]*[^a-z]',
  ' sobbing[^a-z]',
  ' aching[^a-z]',
  ' evil[a-z-]*[^a-z]',
  ' masochis[a-z-]*[^a-z]',
  ' sobs[^a-z]',
  ' advers[a-z-]*[^a-z]',
  ' excruciat[a-z-]*[^a-z]',
  ' melanchol[a-z-]*[^a-z]',
  ' solemn[a-z-]*[^a-z]',
  ' afraid[^a-z]',
 ' exhaust[a-z-]*[^a-z]',
 ' mess[^a-z]',
 ' sorrow[a-z-]*[^a-z]',
 ' aggravat[a-z-]*[^a-z]',
 ' fail[a-z-]*[^a-z]',
 ' messy[^a-z]',
 ' aggress[a-z-]*[^a-z]',
 ' fake[^a-z]',
 ' miser[a-z-]*[^a-z]',
 ' spite[a-z-]*[^a-z]',
 ' agitat[a-z-]*[^a-z]',
 ' fatal[a-z-]*[^a-z]',
 ' miss[^a-z]',
 ' stammer[a-z-]*[^a-z]',
 ' agoniz[a-z-]*[^a-z]',
 ' fatigu[a-z-]*[^a-z]',
 ' missed[^a-z]',
 ' stank[^a-z]',
 ' agony[^a-z]',
 ' fault[a-z-]*[^a-z]',
 ' misses[^a-z]',
 ' startl[a-z-]*[^a-z]',
 ' alarm[a-z-]*[^a-z]',
 ' fear[^a-z]',
 ' missing[^a-z]',
 ' steal[a-z-]*[^a-z]',
 ' alone[^a-z]',
 ' feared[^a-z]',
 ' mistak[a-z-]*[^a-z]',
 ' stench[a-z-]*[^a-z]',
 ' anger[a-z-]*[^a-z]',
 ' fearful[a-z-]*[^a-z]',
 ' mock[^a-z]',
 ' stink[a-z-]*[^a-z]',
 ' angr[a-z-]*[^a-z]',
 ' fearing[^a-z]',
 ' mocked[^a-z]',
 ' strain[a-z-]*[^a-z]',
 ' anguish[a-z-]*[^a-z]',
 ' fears[^a-z]',
 ' mocker[a-z-]*[^a-z]',
 ' strange[^a-z]',
 ' annoy[a-z-]*[^a-z]',
 ' feroc[a-z-]*[^a-z]',
 ' mocking[^a-z]',
 ' stress[a-z-]*[^a-z]',
 ' antagoni[a-z-]*[^a-z]',
 ' feud[a-z-]*[^a-z]',
 ' mocks[^a-z]',
 ' struggl[a-z-]*[^a-z]',
 ' anxi[a-z-]*[^a-z]',
 ' fiery[^a-z]',
 ' molest[a-z-]*[^a-z]',
 ' stubborn[a-z-]*[^a-z]',
 ' apath[a-z-]*[^a-z]',
 ' fight[a-z-]*[^a-z]',
 ' mooch[a-z-]*[^a-z]',
 ' stunk[^a-z]',
 ' appall[a-z-]*[^a-z]',
 ' fired[^a-z]',
 ' moodi[a-z-]*[^a-z]',
 ' stunned[^a-z]',
 ' apprehens[a-z-]*[^a-z]',
 ' flunk[a-z-]*[^a-z]',
 ' moody[^a-z]',
 ' stuns[^a-z]',
 ' argh[a-z-]*[^a-z]',
 ' foe[a-z-]*[^a-z]',
 ' moron[a-z-]*[^a-z]',
 ' stupid[a-z-]*[^a-z]',
 ' argu[a-z-]*[^a-z]',
 ' fool[a-z-]*[^a-z]',
 ' mourn[a-z-]*[^a-z]',
 ' stutter[a-z-]*[^a-z]',
 ' arrogan[a-z-]*[^a-z]',
 ' forbid[a-z-]*[^a-z]',
 ' murder[a-z-]*[^a-z]',
 ' submissive[a-z-]*[^a-z]',
 ' asham[a-z-]*[^a-z]',
 ' fought[^a-z]',
 ' nag[a-z-]*[^a-z]',
 ' suck[^a-z]',
 ' assault[a-z-]*[^a-z]',
 ' frantic[a-z-]*[^a-z]',
 ' nast[a-z-]*[^a-z]',
 ' sucked[^a-z]',
 ' freak[a-z-]*[^a-z]',
 ' needy[^a-z]',
 ' sucker[a-z-]*[^a-z]',
 ' attack[a-z-]*[^a-z]',
 ' fright[a-z-]*[^a-z]',
 ' neglect[a-z-]*[^a-z]',
 ' aversi[a-z-]*[^a-z]',
 ' frustrat[a-z-]*[^a-z]',
 ' nerd[a-z-]*[^a-z]',
 ' sucky[^a-z]',
 ' avoid[a-z-]*[^a-z]',
 ' nervous[a-z-]*[^a-z]',
 ' suffer[^a-z]',
 ' awful[^a-z]',
 ' neurotic[a-z-]*[^a-z]',
 ' suffered[^a-z]',
 ' awkward[a-z-]*[^a-z]',
 ' numb[a-z-]*[^a-z]',
 ' sufferer[a-z-]*[^a-z]',
 ' bad[^a-z]',
 ' obnoxious[a-z-]*[^a-z]',
 ' suffering[^a-z]',
 ' bashful[a-z-]*[^a-z]',
 ' obsess[a-z-]*[^a-z]',
 ' suffers[^a-z]',
 ' bastard[a-z-]*[^a-z]',
 ' fume[a-z-]*[^a-z]',
 ' offence[a-z-]*[^a-z]',
 ' suspicio[a-z-]*[^a-z]',
 ' battl[a-z-]*[^a-z]',
 ' fuming[^a-z]',
 ' offend[a-z-]*[^a-z]',
 ' tantrum[a-z-]*[^a-z]',
 ' beaten[^a-z]',
 ' furious[a-z-]*[^a-z]',
 ' offens[a-z-]*[^a-z]',
 ' tears[^a-z]',
 ' fury[^a-z]',
 ' outrag[a-z-]*[^a-z]',
 ' teas[a-z-]*[^a-z]',
 ' bitter[a-z-]*[^a-z]',
 ' geek[a-z-]*[^a-z]',
 ' overwhelm[a-z-]*[^a-z]',
 ' temper[^a-z]',
 ' blam[a-z-]*[^a-z]',
 ' gloom[a-z-]*[^a-z]',
 ' pain[^a-z]',
 ' tempers[^a-z]',
 ' bore[a-z-]*[^a-z]',
 ' goddam[a-z-]*[^a-z]',
 ' pained[^a-z]',
 ' tense[a-z-]*[^a-z]',
 ' boring[^a-z]',
 ' gossip[a-z-]*[^a-z]',
 ' painf[a-z-]*[^a-z]',
 ' tensing[^a-z]',
 ' bother[a-z-]*[^a-z]',
 ' grave[a-z-]*[^a-z]',
 ' paining[^a-z]',
 ' tension[a-z-]*[^a-z]',
 ' broke[^a-z]',
 ' greed[a-z-]*[^a-z]',
 ' pains[^a-z]',
 ' terribl[a-z-]*[^a-z]',
 ' brutal[a-z-]*[^a-z]',
 ' grief[^a-z]',
 ' panic[a-z-]*[^a-z]',
 ' terrified[^a-z]',
 ' burden[a-z-]*[^a-z]',
 ' griev[a-z-]*[^a-z]',
 ' paranoi[a-z-]*[^a-z]',
 ' terrifies[^a-z]',
 ' careless[a-z-]*[^a-z]',
 ' grim[a-z-]*[^a-z]',
 ' pathetic[a-z-]*[^a-z]',
 ' terrify[^a-z]',
 ' cheat[a-z-]*[^a-z]',
 ' gross[a-z-]*[^a-z]',
 ' peculiar[a-z-]*[^a-z]',
 ' terrifying[^a-z]',
 ' complain[a-z-]*[^a-z]',
 ' grouch[a-z-]*[^a-z]',
 ' perver[a-z-]*[^a-z]',
 ' terror[a-z-]*[^a-z]',
 ' confront[a-z-]*[^a-z]',
 ' grr[a-z-]*[^a-z]',
 ' pessimis[a-z-]*[^a-z]',
 ' thief[^a-z]',
 ' confus[a-z-]*[^a-z]',
 ' guilt[a-z-]*[^a-z]',
 ' petrif[a-z-]*[^a-z]',
 ' thieve[a-z-]*[^a-z]',
 ' contempt[a-z-]*[^a-z]',
 ' harass[a-z-]*[^a-z]',
 ' pettie[a-z-]*[^a-z]',
 ' threat[a-z-]*[^a-z]',
 ' contradic[a-z-]*[^a-z]',
 ' harm[^a-z]',
 ' petty[a-z-]*[^a-z]',
 ' ticked[^a-z]',
 ' harmed[^a-z]',
 ' phobi[a-z-]*[^a-z]',
 ' timid[a-z-]*[^a-z]',
 ' harmful[a-z-]*[^a-z]',
 ' piss[a-z-]*[^a-z]',
 ' tortur[a-z-]*[^a-z]',
 ' craz[a-z-]*[^a-z]',
 ' harming[^a-z]',
 ' piti[a-z-]*[^a-z]',
 ' tough[a-z-]*[^a-z]',
 ' cried[^a-z]',
 ' harms[^a-z]',
 ' pity[a-z-]*[^a-z]',
 ' traged[a-z-]*[^a-z]',
 ' cries[^a-z]',
 ' hate[^a-z]',
 ' poison[a-z-]*[^a-z]',
 ' tragic[a-z-]*[^a-z]',
 ' critical[^a-z]',
 ' hated[^a-z]',
 ' prejudic[a-z-]*[^a-z]',
 ' trauma[a-z-]*[^a-z]',
 ' critici[a-z-]*[^a-z]',
 ' hateful[a-z-]*[^a-z]',
 ' pressur[a-z-]*[^a-z]',
 ' trembl[a-z-]*[^a-z]',
 ' crude[a-z-]*[^a-z]',
 ' hater[a-z-]*[^a-z]',
 ' prick[a-z-]*[^a-z]',
 ' trick[a-z-]*[^a-z]',
 ' cruel[a-z-]*[^a-z]',
 ' hates[^a-z]',
 ' trite[^a-z]',
 ' crushed[^a-z]',
 ' hating[^a-z]',
 ' protest[^a-z]',
 ' trivi[a-z-]*[^a-z]',
 ' cry[^a-z]',
 ' hatred[^a-z]',
 ' protested[^a-z]',
 ' troubl[a-z-]*[^a-z]',
 ' crying[^a-z]',
 ' heartbreak[a-z-]*[^a-z]',
 ' protesting[^a-z]',
 ' turmoil[^a-z]',
 ' cunt[a-z-]*[^a-z]',
 ' heartbroke[a-z-]*[^a-z]',
 ' puk[a-z-]*[^a-z]',
 ' ugh[^a-z]',
 ' cut[^a-z]',
 ' heartless[a-z-]*[^a-z]',
 ' punish[a-z-]*[^a-z]',
 ' ugl[a-z-]*[^a-z]',
 ' cynic[a-z-]*[^a-z]',
 ' rage[a-z-]*[^a-z]',
 ' unattractive[^a-z]',
 ' damag[a-z-]*[^a-z]',
 ' hellish[^a-z]',
 ' raging[^a-z]',
 ' uncertain[a-z-]*[^a-z]',
 ' damn[a-z-]*[^a-z]',
 ' helpless[a-z-]*[^a-z]',
 ' rancid[a-z-]*[^a-z]',
 ' uncomfortabl[a-z-]*[^a-z]',
 ' danger[a-z-]*[^a-z]',
 ' hesita[a-z-]*[^a-z]',
 ' rape[a-z-]*[^a-z]',
 ' uncontrol[a-z-]*[^a-z]',
 ' daze[a-z-]*[^a-z]',
 ' homesick[a-z-]*[^a-z]',
 ' raping[^a-z]',
 ' uneas[a-z-]*[^a-z]',
 ' decay[a-z-]*[^a-z]',
 ' hopeless[a-z-]*[^a-z]',
 ' rapist[a-z-]*[^a-z]',
 ' unfortunate[a-z-]*[^a-z]',
 ' defeat[a-z-]*[^a-z]',
 ' horr[a-z-]*[^a-z]',
 ' rebel[a-z-]*[^a-z]',
 ' unfriendly[^a-z]',
 ' defect[a-z-]*[^a-z]',
 ' hostil[a-z-]*[^a-z]',
 ' reek[a-z-]*[^a-z]',
 ' ungrateful[a-z-]*[^a-z]',
 ' defenc[a-z-]*[^a-z]',
 ' humiliat[a-z-]*[^a-z]',
 ' regret[a-z-]*[^a-z]',
 ' unhapp[a-z-]*[^a-z]',
 ' defens[a-z-]*[^a-z]',
 ' hurt[a-z-]*[^a-z]',
 ' reject[a-z-]*[^a-z]',
 ' unimportant[^a-z]',
 ' degrad[a-z-]*[^a-z]',
 ' idiot[^a-z]',
 ' reluctan[a-z-]*[^a-z]',
 ' unimpress[a-z-]*[^a-z]',
 ' depress[a-z-]*[^a-z]',
 ' ignor[a-z-]*[^a-z]',
 ' remorse[a-z-]*[^a-z]',
 ' unkind[^a-z]',
 ' depriv[a-z-]*[^a-z]',
 ' immoral[a-z-]*[^a-z]',
 ' repress[a-z-]*[^a-z]',
 ' unlov[a-z-]*[^a-z]',
 ' despair[a-z-]*[^a-z]',
 ' impatien[a-z-]*[^a-z]',
 ' resent[a-z-]*[^a-z]',
 ' unpleasant[^a-z]',
 ' desperat[a-z-]*[^a-z]',
 ' impersonal[^a-z]',
 ' resign[a-z-]*[^a-z]',
 ' unprotected[^a-z]',
 ' despis[a-z-]*[^a-z]',
 ' impolite[a-z-]*[^a-z]',
 ' restless[a-z-]*[^a-z]',
 ' unsavo[a-z-]*[^a-z]',
 ' destroy[a-z-]*[^a-z]',
 ' inadequa[a-z-]*[^a-z]',
 ' revenge[a-z-]*[^a-z]',
 ' unsuccessful[a-z-]*[^a-z]',
 ' destruct[a-z-]*[^a-z]',
 ' indecis[a-z-]*[^a-z]',
 ' ridicul[a-z-]*[^a-z]',
 ' unsure[a-z-]*[^a-z]',
 ' devastat[a-z-]*[^a-z]',
 ' ineffect[a-z-]*[^a-z]',
 ' rigid[a-z-]*[^a-z]',
 ' unwelcom[a-z-]*[^a-z]',
 ' devil[a-z-]*[^a-z]',
 ' inferior[a-z-]*[^a-z]',
 ' risk[a-z-]*[^a-z]',
 ' upset[a-z-]*[^a-z]',
 ' difficult[a-z-]*[^a-z]',
 ' inhib[a-z-]*[^a-z]',
 ' rotten[^a-z]',
 ' uptight[a-z-]*[^a-z]',
 ' disadvantage[a-z-]*[^a-z]',
 ' insecur[a-z-]*[^a-z]',
 ' rude[a-z-]*[^a-z]',
 ' useless[a-z-]*[^a-z]',
 ' disagree[a-z-]*[^a-z]',
 ' insincer[a-z-]*[^a-z]',
 ' ruin[a-z-]*[^a-z]',
 ' vain[^a-z]',
 ' disappoint[a-z-]*[^a-z]',
 ' insult[a-z-]*[^a-z]',
 ' sad[^a-z]',
 ' vanity[^a-z]',
 ' disaster[a-z-]*[^a-z]',
 ' interrup[a-z-]*[^a-z]',
 ' sadde[a-z-]*[^a-z]',
 ' vicious[a-z-]*[^a-z]',
 ' discomfort[a-z-]*[^a-z]',
 ' intimidat[a-z-]*[^a-z]',
 ' sadly[^a-z]',
 ' victim[a-z-]*[^a-z]',
 ' discourag[a-z-]*[^a-z]',
 ' irrational[a-z-]*[^a-z]',
 ' sadness[^a-z]',
 ' vile[^a-z]',
 ' disgust[a-z-]*[^a-z]',
 ' irrita[a-z-]*[^a-z]',
 ' sarcas[a-z-]*[^a-z]',
 ' villain[a-z-]*[^a-z]',
 ' dishearten[a-z-]*[^a-z]',
 ' isolat[a-z-]*[^a-z]',
 ' savage[a-z-]*[^a-z]',
 ' violat[a-z-]*[^a-z]',
 ' disillusion[a-z-]*[^a-z]',
 ' jaded[^a-z]',
 ' scare[a-z-]*[^a-z]',
 ' violent[a-z-]*[^a-z]',
 ' dislike[^a-z]',
 ' jealous[a-z-]*[^a-z]',
 ' scaring[^a-z]',
 ' vulnerab[a-z-]*[^a-z]',
 ' disliked[^a-z]',
 ' jerk[^a-z]',
 ' scary[^a-z]',
 ' vulture[a-z-]*[^a-z]',
 ' dislikes[^a-z]',
 ' jerked[^a-z]',
 ' sceptic[a-z-]*[^a-z]',
 ' war[^a-z]',
 ' disliking[^a-z]',
 ' jerks[^a-z]',
 ' scream[a-z-]*[^a-z]',
 ' warfare[a-z-]*[^a-z]',
 ' dismay[a-z-]*[^a-z]',
 ' kill[a-z-]*[^a-z]',
 ' screw[a-z-]*[^a-z]',
 ' warred[^a-z]',
 ' dissatisf[a-z-]*[^a-z]',
 ' lame[a-z-]*[^a-z]',
 ' selfish[a-z-]*[^a-z]',
 ' warring[^a-z]',
 ' distract[a-z-]*[^a-z]',
 ' lazie[a-z-]*[^a-z]',
 ' wars[^a-z]',
 ' distraught[^a-z]',
 ' lazy[^a-z]',
 ' weak[a-z-]*[^a-z]',
 ' distress[a-z-]*[^a-z]',
 ' liabilit[a-z-]*[^a-z]',
 ' weapon[a-z-]*[^a-z]',
 ' distrust[a-z-]*[^a-z]',
 ' liar[a-z-]*[^a-z]',
 ' severe[a-z-]*[^a-z]',
 ' weep[a-z-]*[^a-z]',
 ' disturb[a-z-]*[^a-z]',
 ' lied[^a-z]',
 ' shake[a-z-]*[^a-z]',
 ' weird[a-z-]*[^a-z]',
 ' domina[a-z-]*[^a-z]',
 ' lies[^a-z]',
 ' shaki[a-z-]*[^a-z]',
 ' wept[^a-z]',
 ' doom[a-z-]*[^a-z]',
 ' lone[a-z-]*[^a-z]',
 ' shaky[^a-z]',
 ' whine[a-z-]*[^a-z]',
 ' dork[a-z-]*[^a-z]',
 ' longing[a-z-]*[^a-z]',
 ' shame[a-z-]*[^a-z]',
 ' whining[^a-z]',
 ' doubt[a-z-]*[^a-z]',
 ' lose[^a-z]',
 ' whore[a-z-]*[^a-z]',
 ' dread[a-z-]*[^a-z]',
 ' loser[a-z-]*[^a-z]',
 ' shock[a-z-]*[^a-z]',
 ' wicked[a-z-]*[^a-z]',
 ' dull[a-z-]*[^a-z]',
 ' loses[^a-z]',
 ' shook[^a-z]',
 ' wimp[a-z-]*[^a-z]',
 ' dumb[a-z-]*[^a-z]',
 ' losing[^a-z]',
 ' shy[a-z-]*[^a-z]',
 ' witch[^a-z]',
 ' dump[a-z-]*[^a-z]',
 ' loss[a-z-]*[^a-z]',
 ' sicken[a-z-]*[^a-z]',
 ' woe[a-z-]*[^a-z]',
 ' dwell[a-z-]*[^a-z]',
 ' lost[^a-z]',
 ' sin[^a-z]',
 ' worr[a-z-]*[^a-z]',
 ' egotis[a-z-]*[^a-z]',
 ' lous[a-z-]*[^a-z]',
 ' sinister[^a-z]',
 ' worse[a-z-]*[^a-z]',
 ' embarrass[a-z-]*[^a-z]',
 ' low[a-z-]*[^a-z]',
 ' sins[^a-z]',
 ' worst[^a-z]',
 ' emotional[^a-z]',
 ' luckless[a-z-]*[^a-z]',
 ' skeptic[a-z-]*[^a-z]',
 ' worthless[a-z-]*[^a-z]',
 ' empt[a-z-]*[^a-z]',
 ' ludicrous[a-z-]*[^a-z]',
 ' slut[a-z-]*[^a-z]',
 ' wrong[a-z-]*[^a-z]',
 ' enemie[a-z-]*[^a-z]',
 ' lying[^a-z]',
 ' smother[a-z-]*[^a-z]',
 ' yearn[a-z-]*[^a-z]',
 ' enemy[a-z-]*[^a-z]',
 ' mad[^a-z]',
 ' smug[a-z-]*[^a-z]');

   @swearpatterns = (
' arse[^a-z]',
' arsehole[a-z-]*[^a-z]',
' arses[^a-z]',
' ass[^a-z]',
' asses[^a-z]',
' asshole[a-z-]*[^a-z]',
' bastard[a-z-]*[^a-z]',
' bitch[a-z-]*[^a-z]',
' bloody[^a-z]',
' boob[a-z-]*[^a-z]',
' butt[^a-z]',
' butts[^a-z]',
' cock[^a-z]',
' cocks[a-z-]*[^a-z]',
' crap[^a-z]',
' crappy[^a-z]',
' cunt[a-z-]*[^a-z]',
' damn[a-z-]*[^a-z]',
' dang[^a-z]',
' darn[^a-z]',
' dick[^a-z]',
' dicks[^a-z]',
' dyke[a-z-]*[^a-z]',
' fuck[^a-z]',
' fucked[a-z-]*[^a-z]',
' fucker[a-z-]*[^a-z]',
' fuckin[a-z-]*[^a-z]',
' fucks[^a-z]',
' goddam[a-z-]*[^a-z]',
' heck[^a-z]',
' hell[^a-z]',
' homo[^a-z]',
' jeez[^a-z]',
' mofo[^a-z]',
' motherf[a-z-]*[^a-z]',
' nigger[a-z-]*[^a-z]',
' piss[a-z-]*[^a-z]',
' prick[a-z-]*[^a-z]',
' pussy[a-z-]*[^a-z]',
' screw[a-z-]*[^a-z]',
' shit[^a-z]',
' shitting[a-z-]*[^a-z]',
' shity[a-z-]*[^a-z]',
' sob[^a-z]',
' sonofa[a-z-]*[^a-z]',
' suck[^a-z]',
' sucked[^a-z]',
' sucks[^a-z]',
' tit[^a-z]',
' tits[^a-z]',
' titties[^a-z]',
' titty[^a-z]',
' wanker[a-z-]*[^a-z]');

   @negatepatterns = (
' ain.t[^a-z]',
' arent[^a-z]',
' aren.t[^a-z]',
' cannot[^a-z]',
' cant[^a-z]',
' can.t[^a-z]',
' couldnt[^a-z]',
' couldn.t[^a-z]',
' didnt[^a-z]',
' didn.t[^a-z]',
' doesnt[^a-z]',
' doesn.t[^a-z]',
' dont[^a-z]',
' don.t[^a-z]',
' hadnt[^a-z]',
' hadn.t[^a-z]',
' hasnt[^a-z]',
' hasn.t[^a-z]',
' havent[^a-z]',
' haven.t[^a-z]',
' isnt[^a-z]',
' isn.t[^a-z]',
' mustnt[^a-z]',
' must.nt[^a-z]',
' mustn.t[^a-z]',
' neednt[^a-z]',
' need.nt[^a-z]',
' needn.t[^a-z]',
' negat[a-z-]*[^a-z]',
' neither[^a-z]',
' never[^a-z]',
' no[^a-z]',
' nobod[a-z-]*[^a-z]',
' none[^a-z]',
' nope[^a-z]',
' nor[^a-z]',
' not[^a-z]',
' nothing[^a-z]',
' nowhere[^a-z]',
' oughtnt[^a-z]',
' ought.nt[^a-z]',
' oughtn.t[^a-z]',
' shant[^a-z]',
' shan.t[^a-z]',
' shouldnt[^a-z]',
' should.nt[^a-z]',
' shouldn.t[^a-z]',
' uhuh[^a-z]',
' wasnt[^a-z]',
' wasn.t[^a-z]',
' weren.t[^a-z]',
' without[^a-z]',
' wont[^a-z]',
' won.t[^a-z]',
' wouldnt[^a-z]',
' wouldn.t[^a-z]');

   @sympathypatterns = (
 'it.s very weird',
 '[Ii]t is a little weird',
 '[Ii]t.s weird\.',
 '[Ii]t is kind of weird',
 'Are you serious',
 '[yY]ou must be tired',
 '[yY]ou must be sad',
 'I had the same problem.',
 '[Ii]s it crazy?',
 '[Ii]t.s terrible. ',
 'that.s a tough ',
 'Oh my god',
 'that.s tough.',
 'That must be tough on you',
 'Oh my [gG]od.',
 'That.s a problem',
 'Oh that sucks',
 'Oh, that sucks',
 'That.s tough.',
 'Well, that sort of sucks',
 '[Tt]hat.s too bad.',
 'that.s weird',
 'that sounds weird',
 'yeah, that was weird.',
 'that sounds bad',
 'That seems weird.',
 '[Tt]hat.s terrible.',
' Tt]hat.s terrible.',
 '[Yy]ou must be sad',
 '[Yy]ou must be tired',
 '[Tt]hey.re horrible',
 'Oh no\.[^a-zA-Z]*$',
 );

   @metapatterns = (
 ' speed[^a-z]',
 ' flirt[^a-z]',
 ' questions[^a-z]',
 ' talk[^a-z]',
 ' event[^a-z]',
 ' dating[^a-z]',
 ' awkward[^a-z]',
 ' rating[^a-z]',
 '[^y] rate[^a-z]',
 '[^n]y rate[^a-z]');

   @ipatterns = (
 ' I[^a-zA-Z\']me[^a]',
 ' I[^a-zA-Z\']m[^e]',
 ' I[^a-zA-Z\'][^m]',
 ' I\'d[^a-zA-Z]',
 ' I\'ll[^a-z]',
 ' I\'m[^a-z]',
 ' I\'ve[^a-z]',
 ' me[^a-z]',
 ' Me[^a-z]',
 ' mine[^a-z]',
 ' Mine[^a-z]',
 ' My[^a-z]',
 ' my[^a-z]',
 ' myself[^a-z]',
 ' Myself[^a-z]',
 );


   @umpatterns = (
 ' [Uu][m][^a-z]');

   @uhpatterns = (
 ' [Uu][h][^a-z]');


   @ntripatterns = (
 '[^w] [Ww]hat\?',
 '[^o]w [Ww]hat\?',
 '[^n]ow [Ww]hat\?',
 ' [Ss]orry\?',
 ' [Ee]xcuse me\?',
 ' Huh\?',
 ' [Ww]ho\?',
 ' [Pp]ardon\?',
 ' [sS]ay it again\?',
 ' [sS]ay again.',
 ' [sS]ay again\?',
 ' What was that\?',
 ' What.s that\?',
 ' What.s that\?');

   @likepatterns = (
	   '[^Iduyt][ -]like[^a-z][^i]',
	   '[^l\']d[ -]like[^a-z][^i]',
	   '[^\']t[ -]like[^a-z][^i]',
	   '[^o]u[ -]like[^a-z][^i]',
	   '[^yY]ou[ -]like[^a-z][^i]',
	   '[^l]y[ -]like[^a-z][^i]',
	   '[^l]ly[ -]like[^a-z][^i]',
	   '[^a]lly[ -]like[^a-z][^i]',
	   '[^Iduyt][ -]like[^a-z]i[^t]',
	   '[^l\']d[ -]like[^a-z]i[^t]',
	   '[^\']t[ -]like[^a-z]i[^t]',
	   '[^o]u[ -]like[^a-z]i[^t]',
	   '[^yY]ou[ -]like[^a-z]i[^t]',
	   '[^l]y[ -]like[^a-z]i[^t]',
	   '[^l]ly[ -]like[^a-z]i[^t]',
	   '[^a]lly[ -]like[^a-z]i[^t]',
	   '[^Iduyt][ -]like[^a-z]it[^\.]',
	   '[^l\']d[ -]like[^a-z]it[^\.]',
	   '[^\']t[ -]like[^a-z]it[^\.]',
	   '[^o]u[ -]like[^a-z]it[^\.]',
	   '[^yY]ou[ -]like[^a-z]it[^\.]',
	   '[^l]y[ -]like[^a-z]it[^\.]',
	   '[^l]ly[ -]like[^a-z]it[^\.]',
	   '[^a]lly[ -]like[^a-z]it[^\.]'
);

   @imeanpatterns = (
 ' I mean[^a-z]',
);
   @youknowpatterns = (
 ' [Yy]ou know[^a-z]',
);

   @apprpatterns = (
 ' Absolutely[^a-z]',
 ' Amazing[^a-z]',
 ' All right[^a-z]',
 ' Beautiful[^a-z]',
 ' Awesome[^a-z]',
 ' Boy[^a-z]',
 ' Gee[^a-z]',
 ' God[^a-z]',
 ' Good for you[^a-z]',
 ' Great[^a-z]*$',
 ' How fun[^a-z]',
 ' How interesting[^a-z]',
 ' How nice[^a-z]',
 ' I bet[^a-z]*$',
 ' I can imagine[^a-z]',
 ' I can understand that[^a-z]',
 ' I imagine[^a-z]',
 ' I understand[^a-z]',
 ' I.m sure[^a-z]*$',
 ' Interesting[^a-z]',
 ' It sure does[^a-z]',
 ' Jeez[^a-z]',
 ' Man[^a-z]',
 ' My gosh[^a-z]',
 ' Nice[^a-z]*$',
 ' No kidding[^a-z]',
 ' Of course[^a-z]*$',
 ' Oh boy[^a-z]',
 ' Oh congratulations[^a-z]',
 ' Oh dear[^a-z]',
 ' Oh geez[^a-z]',
 ' Oh good[^a-z]',
 ' Oh gosh[^a-z]',
 ' Oh great[^a-z]',
 ' Oh man[^a-z]',
 ' Oh my God[^a-z]',
 ' Oh my god[^a-z]',
 ' Oh my goodness[^a-z]',
 ' Oh my gosh[^a-z]',
 ' Oh my[^a-z]',
 ' Oh neat[^a-z]',
 ' Oh nice[^a-z]',
 ' Oh no kidding[^a-z]',
 ' Oh wow[^a-z]',
 ' Anyway, wow[^a-z]',
 ' Oh yes[^a-z]',
 ' Oh![^a-z]',
 ' Ooh[^a-z]',
 ' Pretty good[^a-z]',
 ' Sounds like it[^a-z]',
 ' Sure[^a-z]*$',
 ' [tT]hat is great[^a-z]',
 ' [tT]hat is nice[^a-z]',
 ' [tT]hat makes sense[^a-z]',
 ' [tT]hat sounds really good[^a-z]',
 ' [tT]hat sounds great[^a-z]',
 ' [tT]hat sounds nice[^a-z]',
 ' [tT]hat would be great[^a-z]',
 ' [tT]hat would be nice[^a-z]',
 ' [tT]hat.s a good one[^a-z]',
 ' [tT]hat.s a good point[^a-z]',
 ' [tT]hat.s a good question[^a-z]',
 ' [tT]hat.s amazing[^a-z]',
 ' [tT]hat.s cool[^a-z]',
 ' [tT]hat.s. really cool[^a-z]*',
 ' [tT]hat.s for sure[^a-z]',
 ' [tT]hat.s fun[^a-z]',
 ' [tT]hat.s so logical[^a-z]',
 ' [tT]hat.s so great[^a-z]',
 ' [tT]hat.s so funny[^a-z]',
 ' [tT]hat.s so cool[^a-z]',
 ' [tT]hat.s so awesome[^a-z]',
 ' [tT]hat.s awesome[^a-z]',
 ' [tT]hat.s funny[^a-z]',
 ' [tT]hat.s good[^a-z]',
 ' [tT]hat.s great[^a-z]',
 ' [tT]hat.s interesting[^a-z]',
 ' [tT]hat.s it[^a-z]',
 ' [tT]hat.s neat[^a-z]',
 ' [tT]hat.s nice[^a-z]',
 ' [tT]hat.s not bad[^a-z]',
 ' [tT]hat.s okay[^a-z]',
 ' [tT]hat.s pretty good[^a-z]',
 ' [tT]hat.s really nice[^a-z]',
 ' That.s[^a-z]*$',
 ' [tT]here you go[^a-z]',
 ' Very good[^a-z]',
 ' Well great[^a-z]',
 ' Well that.s good[^a-z]',
 ' Wonderful[^a-z]',
 ' Wow that.s great[^a-z]',
 ' Wow[^a-z]',
 ' You.re kidding[^a-z]') ;

   @agreepatterns = (
  ' Definitely[^a-z]',
  ' For sure[^a-z]',
  ' Exactly[^a-z]',
  ' Oh definitely[^a-z]',
  ' Absolutely[^a-z]',
  ' Totally\.',
  ' [tT]hat.s right[^a-z]',
  ' [tT]hat is right[^a-z]',
  ' That.s true[^a-z]',
  ' [tT]hat is true[^a-z]',
   );

   @restartpatterns = (
 '[^ ]--[^ $]',
 '[^ ]-- [^$ ]',
 '[^ ]--  [^$]',
 '[^ :] --[^ $]',
 '[^ :] -- [^$ ]',
 '[^ :] --  [^$]',
 '[^ :]  --[^ $]',
 '[^ :]  -- [^$ ]',
 '[^ :]  --  [^$]',
 '[^-]-[^-a-zA-Z0-9$ ]',
 '[^-]-  *[^$]',
 '[^a-zA-Z]I, I[^a-zA-Z]',
 '[^a-zA-Z][Ss]o, [Ss]o[^a-zA-Z]',
 '[^a-zA-Z][Ii]t.s, [Ii]t.s[^a-zA-Z]',
 '[^a-zA-Z][Ww]hat, [Ww]hat[^a-zA-Z]',
 '[^a-zA-Z][Tt]he, [Tt]he[^a-zA-Z]',
 '[^a-zA-Z][Ll]ike, [Ll]ike[^a-zA-Z]',
 '[^a-zA-Z][Yy]ou, [Yy]ou[^a-zA-Z]',
 '[^a-zA-Z][Aa]nd, [Aa]nd[^a-zA-Z]',
 '[^a-zA-Z][Ii]\'m, [Ii]\'m[^a-zA-Z]',
 '[^a-zA-Z][Mm]y, [Mm]y[^a-zA-Z]',
 '[^a-zA-Z][Tt]hey, [Tt]hey[^a-zA-Z]',
 '[^a-zA-Z][Aa], [Aa][^a-zA-Z]',
 '[^a-zA-Z][Ii]n, [Ii]n[^a-zA-Z]',
 '[^a-zA-Z][Tt]hat\'s, [Tt]hat\'s[^a-zA-Z]',
 '[^a-zA-Z][Tt]hat, [Tt]hat[^a-zA-Z]',
 '[^a-zA-Z][Tt]o, [Tt]o[^a-zA-Z]',
 '[^a-zA-Z][Ii]t, [Ii]t[^a-zA-Z]',
 '[^a-zA-Z][Ii]s, [Ii]s[^a-zA-Z]',
 '[^a-zA-Z][Hh]ow, [Hh]ow[^a-zA-Z]',
 '[^a-zA-Z][Ww]here, [Ww]here[^a-zA-Z]',
 '[^a-zA-Z][Bb]ut, [Bb]ut[^a-zA-Z]',
 '[^a-zA-Z][Tt]his, [Tt]his[^a-zA-Z]',
 '[^a-zA-Z][Nn]ot, [Nn]ot[^a-zA-Z]',
 '[^a-zA-Z][Yy]ou\'re, [Yy]ou\'re[^a-zA-Z]',
 '[^a-zA-Z][Tt]here, [Tt]here[^a-zA-Z]',
 '[^a-zA-Z][Jj]ust, [Jj]ust[^a-zA-Z]',
 '[^a-zA-Z][Yy]our, [Yy]our[^a-zA-Z]',
 '[^a-zA-Z][Ww]ay, [Ww]ay[^a-zA-Z]',
 '[^a-zA-Z][Oo]r, [Oo]r[^a-zA-Z]',
 '[^a-zA-Z][Ff]or, [Ff]or[^a-zA-Z]',
 '[^a-zA-Z][Hh]e, [Hh]e[^a-zA-Z]',
 '[^a-zA-Z][Dd]o, [Dd]o[^a-zA-Z]',
 '[^a-zA-Z][Ww]hich, [Ww]hich[^a-zA-Z]',
 '[^a-zA-Z][Ww]e, [Ww]e[^a-zA-Z]',
 '[^a-zA-Z][Tt]here\'s, [Tt]here\'s[^a-zA-Z]',
 '[^a-zA-Z][Pp]retty, [Pp]retty[^a-zA-Z]',
 '[^a-zA-Z][Ww]hy, [Ww]hy[^a-zA-Z]',
 '[^a-zA-Z][Ll]ong, [Ll]ong[^a-zA-Z]',
 '[^a-zA-Z][Ww]ho, [Ww]ho[^a-zA-Z]',
 '[^a-zA-Z][Tt]hey\'re, [Tt]hey\'re[^a-zA-Z]',
 '[^a-zA-Z][Oo]n, [Oo]n[^a-zA-Z]',
 '[^a-zA-Z][Ii]\'ve, [Ii]\'ve[^a-zA-Z]',
 '[^a-zA-Z][Ww]ith, [Ww]ith[^a-zA-Z]',
 '[^a-zA-Z][Ww]hat\'s, [Ww]hat\'s[^a-zA-Z]',
 '[^a-zA-Z][Ss]ome, [Ss]ome[^a-zA-Z]',
 '[^a-zA-Z][Oo]ur, [Oo]ur[^a-zA-Z]',
 '[^a-zA-Z][Nn]ow, [Nn]ow[^a-zA-Z]',
 '[^a-zA-Z][Hh]ere, [Hh]ere[^a-zA-Z]',
 '[^a-zA-Z][Dd]on\'t, [Dd]on\'t[^a-zA-Z]',
 '[^a-zA-Z][Cc]lick, [Cc]lick[^a-zA-Z]',
 '[^a-zA-Z][Aa]s, [Aa]s[^a-zA-Z]',
 '[^a-zA-Z][Yy]ear, [Yy]ear[^a-zA-Z]',
 '[^a-zA-Z][Ww]hen, [Ww]hen[^a-zA-Z]',
 '[^a-zA-Z][Tt]hinking, [Tt]hinking[^a-zA-Z]',
 '[^a-zA-Z][Tt]hese, [Tt]hese[^a-zA-Z]',
 '[^a-zA-Z][Tt]hen, [Tt]hen[^a-zA-Z]',
 '[^a-zA-Z][Tt]heir, [Tt]heir[^a-zA-Z]',
 '[^a-zA-Z][Tt]ainted, [Tt]ainted[^a-zA-Z]',
 '[^a-zA-Z][Ss]tudy, [Ss]tudy[^a-zA-Z]',
 '[^a-zA-Z][Ss]tay, [Ss]tay[^a-zA-Z]',
 '[^a-zA-Z][Ss]tanford, [Ss]tanford[^a-zA-Z]',
 '[^a-zA-Z][Ss]lept, [Ss]lept[^a-zA-Z]',
 '[^a-zA-Z][Ss]ide, [Ss]ide[^a-zA-Z]',
 '[^a-zA-Z][Ss]hoot, [Ss]hoot[^a-zA-Z]',
 '[^a-zA-Z][Ss]he\'s, [Ss]he\'s[^a-zA-Z]',
 '[^a-zA-Z][Ss]he, [Ss]he[^a-zA-Z]',
 '[^a-zA-Z][Ss]ee, [Ss]ee[^a-zA-Z]',
 '[^a-zA-Z][Nn]ext, [Nn]ext[^a-zA-Z]',
 '[^a-zA-Z][Mm]ore, [Mm]ore[^a-zA-Z]',
 '[^a-zA-Z][Mm]asters, [Mm]asters[^a-zA-Z]',
 '[^a-zA-Z][Ll]ibrary, [Ll]ibrary[^a-zA-Z]',
 '[^a-zA-Z][Ii]ts, [Ii]ts[^a-zA-Z]',
 '[^a-zA-Z][Ii]ndian, [Ii]ndian[^a-zA-Z]',
 '[^a-zA-Z][Ii]\'ll, [Ii]\'ll[^a-zA-Z]',
 '[^a-zA-Z][Gg]raduate, [Gg]raduate[^a-zA-Z]',
 '[^a-zA-Z][Ff]rance, [Ff]rance[^a-zA-Z]',
 '[^a-zA-Z][Ee]very, [Ee]very[^a-zA-Z]',
 '[^a-zA-Z][Ee]ducation, [Ee]ducation[^a-zA-Z]',
 '[^a-zA-Z][Dd]own, [Dd]own[^a-zA-Z]',
 '[^a-zA-Z][Cc]ity, [Cc]ity[^a-zA-Z]',
 '[^a-zA-Z][Bb]eginner, [Bb]eginner[^a-zA-Z]',
 '[^a-zA-Z][Bb]efore, [Bb]efore[^a-zA-Z]',
 '[^a-zA-Z][Aa]t, [Aa]t[^a-zA-Z]',
 '[^a-zA-Z][Aa]re, [Aa]re[^a-zA-Z]',
 '[^a-zA-Z][Aa]lways, [Aa]lways[^a-zA-Z]',
 '[^a-zA-Z][Aa]ll, [Aa]ll[^a-zA-Z]',
 '[^a-zA-Z][Aa]fter, [Aa]fter[^a-zA-Z]',
 '[^a-zA-Z][Aa]ctually, [Aa]ctually[^a-zA-Z]',
 '[^a-zA-Z][Aa]bout, [Aa]bout[^a-zA-Z]',
 '[^a-zA-Z][Ww]riting, [Ww]riting[^a-zA-Z]',
 '[^a-zA-Z][Ww]rite, [Ww]rite[^a-zA-Z]',
 '[^a-zA-Z][Ww]herever, [Ww]herever[^a-zA-Z]',
 '[^a-zA-Z][Ww]hereas, [Ww]hereas[^a-zA-Z]',
 '[^a-zA-Z][Ww]henever, [Ww]henever[^a-zA-Z]',
 '[^a-zA-Z][Ww]hatever, [Ww]hatever[^a-zA-Z]',
 '[^a-zA-Z][Ww]e\'ll, [Ww]e\'ll[^a-zA-Z]',
 '[^a-zA-Z][Ww]as, [Ww]as[^a-zA-Z]',
 '[^a-zA-Z][Vv]arious, [Vv]arious[^a-zA-Z]',
 '[^a-zA-Z][Vv]ague, [Vv]ague[^a-zA-Z]',
 '[^a-zA-Z][Uu]s, [Uu]s[^a-zA-Z]',
 '[^a-zA-Z][Tt]ry, [Tt]ry[^a-zA-Z]',
 '[^a-zA-Z][Tt]op, [Tt]op[^a-zA-Z]',
 '[^a-zA-Z][Tt]ill, [Tt]ill[^a-zA-Z]',
 '[^a-zA-Z][Tt]hings, [Tt]hings[^a-zA-Z]',
 '[^a-zA-Z][Tt]hey\'ll, [Tt]hey\'ll[^a-zA-Z]',
 '[^a-zA-Z][Tt]heory, [Tt]heory[^a-zA-Z]',
 '[^a-zA-Z][Tt]eenage, [Tt]eenage[^a-zA-Z]',
 '[^a-zA-Z][Tt]echnically, [Tt]echnically[^a-zA-Z]',
 '[^a-zA-Z][Ss]panish, [Ss]panish[^a-zA-Z]',
 '[^a-zA-Z][Ss]outh, [Ss]outh[^a-zA-Z]',
 '[^a-zA-Z][Ss]ounds, [Ss]ounds[^a-zA-Z]',
 '[^a-zA-Z][Ss]olar, [Ss]olar[^a-zA-Z]',
 '[^a-zA-Z][Ss]mart, [Ss]mart[^a-zA-Z]',
 '[^a-zA-Z][Ss]mall, [Ss]mall[^a-zA-Z]',
 '[^a-zA-Z][Ss]ingaporeans, [Ss]ingaporeans[^a-zA-Z]',
 '[^a-zA-Z][Ss]hould, [Ss]hould[^a-zA-Z]',
 '[^a-zA-Z][Ss]hock, [Ss]hock[^a-zA-Z]',
 '[^a-zA-Z][Ss]eventy, [Ss]eventy[^a-zA-Z]',
 '[^a-zA-Z][Ss]eparate, [Ss]eparate[^a-zA-Z]',
 '[^a-zA-Z][Ss]econds, [Ss]econds[^a-zA-Z]',
 '[^a-zA-Z][Ss]eating, [Ss]eating[^a-zA-Z]',
 '[^a-zA-Z][Ss]ample, [Ss]ample[^a-zA-Z]',
 '[^a-zA-Z][Ss]ame, [Ss]ame[^a-zA-Z]',
 '[^a-zA-Z][Rr]omania, [Rr]omania[^a-zA-Z]',
 '[^a-zA-Z][Rr]obots, [Rr]obots[^a-zA-Z]',
 '[^a-zA-Z][Rr]esearching, [Rr]esearching[^a-zA-Z]',
 '[^a-zA-Z][Pp]ut, [Pp]ut[^a-zA-Z]',
 '[^a-zA-Z][Pp]owerless, [Pp]owerless[^a-zA-Z]',
 '[^a-zA-Z][Pp]owell\'s, [Pp]owell\'s[^a-zA-Z]',
 '[^a-zA-Z][Pp]ostpone, [Pp]ostpone[^a-zA-Z]',
 '[^a-zA-Z][Pp]leasure, [Pp]leasure[^a-zA-Z]',
 '[^a-zA-Z][Pp]eople, [Pp]eople[^a-zA-Z]',
 '[^a-zA-Z][Pp]alo, [Pp]alo[^a-zA-Z]',
 '[^a-zA-Z][Oo]ther, [Oo]ther[^a-zA-Z]',
 '[^a-zA-Z][Oo]paque, [Oo]paque[^a-zA-Z]',
 '[^a-zA-Z][Oo]f, [Oo]f[^a-zA-Z]',
 '[^a-zA-Z][Oo]cean, [Oo]cean[^a-zA-Z]',
 '[^a-zA-Z][Nn]orth, [Nn]orth[^a-zA-Z]',
 '[^a-zA-Z][Nn]ever, [Nn]ever[^a-zA-Z]',
 '[^a-zA-Z][Mm]ri, [Mm]ri[^a-zA-Z]',
 '[^a-zA-Z][Mm]ichigan, [Mm]ichigan[^a-zA-Z]',
 '[^a-zA-Z][Mm]et, [Mm]et[^a-zA-Z]',
 '[^a-zA-Z][Mm]edicine, [Mm]edicine[^a-zA-Z]',
 '[^a-zA-Z][Mm]edical, [Mm]edical[^a-zA-Z]',
 '[^a-zA-Z][Mm]echanical, [Mm]echanical[^a-zA-Z]',
 '[^a-zA-Z][Mm]assive, [Mm]assive[^a-zA-Z]',
 '[^a-zA-Z][Mm]aking, [Mm]aking[^a-zA-Z]',
 '[^a-zA-Z][Mm]akes, [Mm]akes[^a-zA-Z]',
 '[^a-zA-Z][Mm]ainly, [Mm]ainly[^a-zA-Z]',
 '[^a-zA-Z][Ll]ittle, [Ll]ittle[^a-zA-Z]',
 '[^a-zA-Z][Ll]et\'s, [Ll]et\'s[^a-zA-Z]',
 '[^a-zA-Z][Ll]and, [Ll]and[^a-zA-Z]',
 '[^a-zA-Z][Kk]now, [Kk]now[^a-zA-Z]',
 '[^a-zA-Z][Kk]ey, [Kk]ey[^a-zA-Z]',
 '[^a-zA-Z][Kk]eep, [Kk]eep[^a-zA-Z]',
 '[^a-zA-Z][Jj]ustice, [Jj]ustice[^a-zA-Z]',
 '[^a-zA-Z][Ii]nterrupt, [Ii]nterrupt[^a-zA-Z]',
 '[^a-zA-Z][Ii]nstead, [Ii]nstead[^a-zA-Z]',
 '[^a-zA-Z][Hh]p, [Hh]p[^a-zA-Z]',
 '[^a-zA-Z][Hh]ow\'d, [Hh]ow\'d[^a-zA-Z]',
 '[^a-zA-Z][Hh]ouse, [Hh]ouse[^a-zA-Z]',
 '[^a-zA-Z][Hh]ook, [Hh]ook[^a-zA-Z]',
 '[^a-zA-Z][Hh]ome, [Hh]ome[^a-zA-Z]',
 '[^a-zA-Z][Hh]ealth, [Hh]ealth[^a-zA-Z]',
 '[^a-zA-Z][Hh]e\'s, [Hh]e\'s[^a-zA-Z]',
 '[^a-zA-Z][Hh]ave, [Hh]ave[^a-zA-Z]',
 '[^a-zA-Z][Hh]as, [Hh]as[^a-zA-Z]',
 '[^a-zA-Z][Hh]ard, [Hh]ard[^a-zA-Z]',
 '[^a-zA-Z][Hh]appy, [Hh]appy[^a-zA-Z]',
 '[^a-zA-Z][Hh]appens, [Hh]appens[^a-zA-Z]',
 '[^a-zA-Z][Hh]ad, [Hh]ad[^a-zA-Z]',
 '[^a-zA-Z][Gg]rad, [Gg]rad[^a-zA-Z]',
 '[^a-zA-Z][Gg]ot, [Gg]ot[^a-zA-Z]',
 '[^a-zA-Z][Gg]irls, [Gg]irls[^a-zA-Z]',
 '[^a-zA-Z][Gg]etting, [Gg]etting[^a-zA-Z]',
 '[^a-zA-Z][Gg]erman, [Gg]erman[^a-zA-Z]',
 '[^a-zA-Z][Ff]unny, [Ff]unny[^a-zA-Z]',
 '[^a-zA-Z][Ff]ull, [Ff]ull[^a-zA-Z]',
 '[^a-zA-Z][Ff]rom, [Ff]rom[^a-zA-Z]',
 '[^a-zA-Z][Ff]rench, [Ff]rench[^a-zA-Z]',
 '[^a-zA-Z][Ff]our, [Ff]our[^a-zA-Z]',
 '[^a-zA-Z][Ff]orget, [Ff]orget[^a-zA-Z]',
 '[^a-zA-Z][Ff]irst, [Ff]irst[^a-zA-Z]',
 '[^a-zA-Z][Ff]inals, [Ff]inals[^a-zA-Z]',
 '[^a-zA-Z][Ff]eeling, [Ff]eeling[^a-zA-Z]',
 '[^a-zA-Z][Ff]ar, [Ff]ar[^a-zA-Z]',
 '[^a-zA-Z][Ff]ail, [Ff]ail[^a-zA-Z]',
 '[^a-zA-Z][Ee]ven, [Ee]ven[^a-zA-Z]',
 '[^a-zA-Z][Ee]ngineering, [Ee]ngineering[^a-zA-Z]',
 '[^a-zA-Z][Ee]dmonton, [Ee]dmonton[^a-zA-Z]',
 '[^a-zA-Z][Ee]ach, [Ee]ach[^a-zA-Z]',
 '[^a-zA-Z][Dd]uring, [Dd]uring[^a-zA-Z]',
 '[^a-zA-Z][Dd]oesn\'t, [Dd]oesn\'t[^a-zA-Z]',
 '[^a-zA-Z][Dd]ignity, [Dd]ignity[^a-zA-Z]',
 '[^a-zA-Z][Dd]ifferent, [Dd]ifferent[^a-zA-Z]',
 '[^a-zA-Z][Dd]id, [Dd]id[^a-zA-Z]',
 '[^a-zA-Z][Dd]evelopmental, [Dd]evelopmental[^a-zA-Z]',
 '[^a-zA-Z][Dd]epartment, [Dd]epartment[^a-zA-Z]',
 '[^a-zA-Z][Cc]onsulting, [Cc]onsulting[^a-zA-Z]',
 '[^a-zA-Z][Cc]old, [Cc]old[^a-zA-Z]',
 '[^a-zA-Z][Cc]atalan, [Cc]atalan[^a-zA-Z]',
 '[^a-zA-Z][Bb]urrito, [Bb]urrito[^a-zA-Z]',
 '[^a-zA-Z][Bb]ig, [Bb]ig[^a-zA-Z]',
 '[^a-zA-Z][Bb]ecause, [Bb]ecause[^a-zA-Z]',
 '[^a-zA-Z][Bb]atman, [Bb]atman[^a-zA-Z]',
 '[^a-zA-Z][Bb]asically, [Bb]asically[^a-zA-Z]',
 '[^a-zA-Z][Bb]angs, [Bb]angs[^a-zA-Z]',
 '[^a-zA-Z][Aa]round, [Aa]round[^a-zA-Z]',
 '[^a-zA-Z][Aa]pplying, [Aa]pplying[^a-zA-Z]',
 '[^a-zA-Z][Aa]nyway, [Aa]nyway[^a-zA-Z]',
 '[^a-zA-Z][Aa]nything, [Aa]nything[^a-zA-Z]',
 '[^a-zA-Z][Aa]m, [Aa]m[^a-zA-Z]',
 '[^a-zA-Z][Aa]lmost, [Aa]lmost[^a-zA-Z]',
 '[^a-zA-Z][Aa]head, [Aa]head[^a-zA-Z]');

   @overlappatterns = (
 '[^htlmor-] *-?- *$',
 '[^uU][htm] *-?- *$',
 '[^bB]ut *-?- *$',
 '[^Ss]o *-?- *$',
 '[^o]r *-?- *$',
 '[^ ]or *-?- *$',
 '[^l]l *-?- *$',
 '[^e]ll *-?- *$',
 '[^wW]ell *-?- *$',
 '[^ ]so *-?- *$');

@funcwords = (
'able',
'am',
'are',
'aren\'t',
'be',
'been',
'being',
'can',
'can\'t',
'cannot',
'could',
'couldn\'t',
'did',
'didn\'t',
'do',
'don\'t',
'get',
'got',
'gotta',
'had',
'hadn\'t',
'hasn\'t',
'have',
'haven\'t',
'is',
'isn\'t',
'may',
'was',
'were',
'will',
'won\'t',
'would',
'would\'ve',
'wouldn\'t',
'\'cause',
'although',
'and',
'as',
'because',
'but',
'if',
'or',
'so',
'then',
'unless',
'whereas',
'while',
'a',
'an',
'each',
'every',
'all',
'lot',
'lots',
'the',
'this',
'those',
'anybody',
'anything',
'anywhere',
'everybody\'s',
'everyone',
'everything',
'everything\'s',
'everywhere',
'he',
'he\'d',
'he\'s',
'her',
'him',
'himself',
'herself',
'his',
'how',
'how\'d',
'how\'s',
'i',
'i\'d',
'i\'ll',
'i\'m',
'i\'ve',
'me',
'my',
'mine',
'myself',
'nobody',
'nothing',
'nowhere',
'one',
'one\'s',
'ones',
'our',
'ours',
'she',
'she\'ll',
'she\'s',
'she\'d',
'somebody',
'someone',
'someplace',
'that',
'that\'d',
'that\'ll',
'that\'s',
'them',
'themselves',
'these',
'they',
'they\'d',
'they\'ll',
'they\'re',
'they\'ve',
'us',
'we',
'we\'d',
'we\'ll',
'we\'re',
'we\'ve',
'what',
'what\'d',
'what\'s',
'whatever',
'when',
'where',
'where\'d',
'where\'s',
'wherever',
'which',
'who',
'who\'s',
'whom',
'whose',
'why',
'you',
'you\'d',
'you\'ll',
'you\'re',
'you\'ve',
'your',
'yours',
'yourself',
'about',
'after',
'against',
'at',
'before',
'by',
'down',
'for',
'from',
'in',
'into',
'it',
'it\'d',
'it\'ll',
'it\'s',
'its',
'itself',
'near',
'of',
'off',
'on',
'out',
'over',
'than',
'to',
'until',
'up',
'with',
'without',
'ah',
'hi',
'huh',
'like',
'mm-hmm',
'oh',
'okay',
'right',
'uh',
'uh-huh',
'uhm',
'um',
'well',
'yeah',
'yep',
'yup',
'just',
'no',
'not',
'really',
'should',
'should\'ve',
'shouldn\'t',
'too',
'very'
);
   @initlaughpatterns = (
'^[^A-Za-z]*\[laughter\]'
   );
   @midlaughpatterns = (
'^.*[A-Za-z].*\[laughter\]'
   );

   @questionpatterns = (
	   '[dD]o you|[dD]id you|[aA]re you|ould you|[cC]an you|\?' 
   );


# ': *-',
# ': *\[interposing\]',


#initialize parameters
#

 open (swbdwords, "swbd.freqlist") or die "Error opening swbdwordlist: $!\n"; 
 while(<swbdwords>){ 
	 chop;
	 ($num,$word) = split;
	 $swbd{$word} = $num;
 }
 open (datewords,"datevocab") or die "Error opening datevocab: $!\n"; 
 while(<datewords>){ 
	 chop;
	 ($num,$word) = split;
	 $swbd{$word} += $num;
 }

$featfile = ">hedge.outfeatures";

open(STDOUT,$featfile) || die("Can't open STDOUT for writing");
 print "date, speaker, turn, starttime, endtime,  hate, work, love, sex, drink, food, negemo, swear, sympathy, negate, hedge, meta, ntri, like, imean, youknow, you, appr, agree, restart, interrupt,  mimicrawcontent, mimicfuncword,  mimicswbdnorm, mimicswbdnormcontentwords,laughmimic,rateofspeech,prevrateofspeech,initlaugh,midlaugh,wordcount,icount,uh,um,question\n";

@txtfiles = </Users/jurafsky/transcripts/t/*.txt>;


foreach $txtfile (@txtfiles) {
#	print "opening $txtfile\n";
    open(DATEIN, $txtfile) or die("can't open transcript file $txtfile!\n");

       $txtfile =~ s/.txt//;
               $txtfile =~ s/.*\///;
    $datename = canonicalizedate($txtfile);
    $malespeaker = maleside($datename);
    $femalespeaker = femaleside($datename);
#    print "for datename $datename male ,$malespeaker, female: $femalespeaker \n";
$i=1;
$j=1;
$last_male_endtime = 0;
$last_female_endtime = 0;
$offset = 0;
	 $prevstarttime = "";
	 $prevsentence = "";
	 $prevfemalemale = "";

while(<DATEIN>) {
 chop;
 if (!/[A-Za-z]/) {
   next;
 }
 # for time extracxtion we remove all lines that start with an /@/, these have known bad times
 # but for lexical feature extraction i'm going to use these lines, so commented out
 #if (/^@/) {
 #next;
 #}
 if (/FILE NAME/) {
   ($junk1,$junk2,$filename) = split(/ /,$_,3);
#   print "file name is $filename\n";
   next;
 }
 if (/AUDIO SOURCE/) {
   ($junk1,$junk2,$junk3) = split(/ /,$_,3);
   next;
 }

 ($time1,$time2,$femalemale,$sentence) = split(/\s+/,$_,4);
 $sentence =~ s/"/'/g;
 if ($time1 =~ /.*:.*:.*\./) {
  $t1 = $time1;
  $t2 = $time2;
  ($junk,$time1) = split(/:/,$t1,2);
  ($junk,$time2) = split(/:/,$t2,2);
 }

 ($minute1,$second1) = split(/:/,$time1);
 ($minute2,$second2) = split(/:/,$time2);
 if ($second2 =~ /\./) {
     $s1 = $second1;
     $s2 = $second2;
     ($second1,$tenth1) = split(/\./,$s1);
     ($second2,$tenth2) = split(/\./,$s2);
 }
 if ($tenth2 ne "") {
     $starttime = $minute1 * 60 + $second1 + $tenth1/10;
     $endtime = $minute2 * 60 + $second2 + $tenth2/10;
    $tenth2="";
 } else {
     $starttime = $minute1 * 60 + $second1;
     if ($starttime < 0) {
	     $starttime = 0;
     }
     $endtime = $minute2 * 60 + $second2;
 }

 # following code commented out because don't have to do offsets
 #if ($femalemale eq "MALE:") {
 #$starttime += $maleoffset;
 #$endtime += $maleoffset;
 #} elsif ($femalemale eq "FEMALE:") {
 #$starttime += $femaleoffset;
 #$endtime += $femaleoffset;
 #}
 #if (($starttime > $endtime) or ($starttime < 0) or ($endtime < 0))  {
    # just ignore any sentences whose end time is before start time.
    # or which are negative because of offsets. usually this means one file starts a few seconds before
    # the other, and the transcript is from the longer file.
    #
    #print STDERR "ERROR IN TIME IN $datenumber;";
    #print STDERR "START ", $starttime, "< END ",$endtime," ", $sentence, "\n";
    #next;
#}

 $string=$starttime . ":" . $endtime . ":" . $sentence;
 if ($femalemale eq "MALE:") {
	 if (($i == 1) and ($j == 1)) {
		 $firstturn = "MALE"
	 }
	 if ($prevfemalemale eq "MALE:") {
		 #print "consecutive MALE: prev: $prevsentence, curr: $sentence\n";
                 $string=$prevstarttime . ":" . $endtime . ":" . $prevsentence . $sentence;
		 $i = $i-1;
	 }
	 $prevstarttime = $starttime;
	 $prevsentence = $sentence;
	 $prevfemalemale = $femalemale;

	 #if ($starttime > $last_male_endtime) {
	 #$silentstring = $last_male_endtime . ":" . $starttime . ":";
	 #$male[$i++] = $silentstring;
	 #}
	 #if ($starttime < $last_male_endtime) {
	 ##print STDERR "ERROR IN TIME IN $datenumber;";
	 ##print STDERR "Previous turn end:", $last_male_endtime, ", current utt start: ", $starttime, ", sentence #",$sentence, "#\n";
	 ## fix starttime and endtime to be same as the last endtime
	 #$starttime = $last_male_endtime;
	 #$string=$starttime . ":" . $endtime . ":" . $sentence;
	 #}

     $male[$i++] = $string;
     #print "male[$i] = $string\n";
     $last_male_endtime = $endtime;
 } elsif ($femalemale eq "FEMALE:") {
	 if (($i == 1) and ($j == 1)) {
		 $firstturn = "FEMALE"
	 }
	 if ($prevfemalemale eq "FEMALE:") {
		 #print "consecutive female: $sentence\n";
                 $string=$prevstarttime . ":" . $endtime . ":" . $prevsentence . $sentence;
		 $j = $j-1;
	 }
	 $prevstarttime = $starttime;
	 $prevsentence = $sentence;
	 $prevfemalemale = $femalemale;
	 #if ($starttime > $last_female_endtime) {
	 #$silentstring = $last_female_endtime . ":" . $starttime . ":";
##   print "silent female string is $silentstring\n";
	 #$female[$j++] = $silentstring;
	 #}
	 #if ($starttime < $last_female_endtime) {
	 ##print STDERR "ERROR IN TIME IN $datenumber;";
	 ##print STDERR "Previous turn end:", $last_female_endtime, ", current turn start: ", $starttime, " string is: #", $sentence, "#\n";
	 ## fix starttime to be after the last endtime
	 #$starttime = $last_female_endtime;
	 #$string=$starttime . ":" . $endtime . ":" . $sentence;
	 #}
     $female[$j++] = $string;
     $last_female_endtime = $endtime;
 }
 $finalend = $endtime;
}
if ($firstturn eq "MALE") {
	$maleother =  -1;
	$femaleother =  0;
}
if ($firstturn eq "FEMALE") {
	$femaleother =  -1;
	$maleother =  0;
}
$maleintervals = $i-1;
$femaleintervals = $j-1;


  $last_male_time = 0;
  for ($i=1;$i<=$maleintervals;$i++) {
   $malestring = $male[$i];
   ($malestarttime,$maleendtime,$malesentence) = split(/:/,$malestring,3);
   print $malespeaker,",", $femalespeaker,",", $i, ",", $malestarttime, "," , $maleendtime, ",";
   #remove that comment-out

   #print "        intervals [$i]:\n";
   #print "            xmin = $malestarttime\n";
   #print "            xmax = $maleendtime\n";
        $last_male_time = $maleendtime;
        $sentence = $malesentence;
        ($prevstart,$prevend,$previousfemalesentence) = split(/:/,$female[$i+$maleother],3);
	#printf "prevstring is %s\n", $female[$i+$maleother];
#	print "calling countprintvariables with $previousfemalesentence,$malestarttime,$maleendtime,$prevstart,$prevend\n";
	countprintvariables($previousfemalesentence,$malestarttime,$maleendtime,$prevstart,$prevend);
	#print "for male sentence $i, which is:", $male[$i], "\n";
	#printf "the preceding female sentence %d is: %s\n", $i+$maleother, $female[$i+$maleother];
   }

 
  $last_female_time = 0;
  for ($i=1;$i<=$femaleintervals;$i++) {
   $femalestring = $female[$i];
   chomp($femalestring);
   ($femalestarttime,$femaleendtime,$femalesentence) = split(/:/,$femalestring,3);
   print $femalespeaker,",", $malespeaker, "," ,$i, ",", $femalestarttime, "," , $femaleendtime, ",";
   #add an empty interval if needed
   #print "        intervals [$i]:\n";
   #print "            xmin = $femalestarttime\n";
   #print "            xmax = $femaleendtime\n";
   #print '            text = "'.$femalesentence.'"'."\n";
   #
   #
   #
        $last_female_time = $femaleendtime;
        $sentence = $femalesentence;
	#printf "prevstring is *%s*\n", $male[$i+$femaleother];
        ($prevstart,$prevend,$previousmalesentence) = split(/:/,$male[$i+$femaleother],3);
	#printf "prevend is *%s*\n", $prevend;
	#print "calling countprintvariables with ($previousmalesentence,$femalestarttime,$femaleendtime,$prevstart,$prevend\n";
	countprintvariables($previousmalesentence,$femalestarttime,$femaleendtime,$prevstart,$prevend);
	#print "for female sentence $i, which is:", $female[$i], "\n";
	#printf "the preceding male sentence %d is: %s\n", $i+$femaleother, $male[$i+$femaleother];
   }
   }

sub matchpatterninline {
	my (@patterns) = @_;
	my $totalcount = 0;
   foreach $pattern (@patterns) {
	   #print "matching ",$pattern, ":\n";
	   @matches = ($sentence =~ /$pattern/g);
	   $num = $#matches + 1;
	   $totalcount += $num;
	   #if ($num > 0 ){
		   #print "found ", $num, " matches of ", $pattern,"\n";
		   #print $matches[0],$matches[1],$matches[2], "\n";
		   #}
   }
   return $totalcount;
}


sub canonicalizedate {
	 my ($date) = @_;
	 ($one,$two) = split(/-/,$date);
	 if ($one < $two) {
		 return $date;
	 } else {
		 return $two . "-" . $one;
	 }
}
sub maleside{
	 my ($date) = @_;
	 ($one,$two) = split(/-/,$date);
	 if ($one < $two) {
		 return $one;
	 } else {
		 return $two;
	 }
}
sub femaleside{
	 my ($date) = @_;
	 ($one,$two) = split(/-/,$date);
	 if ($two > $one) {
		 return $two;
	 } else {
		 return $one;
	 }
}
sub matchyouinline {
	my ($totalcount) = 0;
        if (!($sentence =~/ [yY]ou/) or ($sentence =~ /\?/) or ($sentence =~ /meet/)) {
#		print "bad sentence $sentence\n";
		return 0;
	}
	@gpatterns = (' [yY]ou');
	@badpatterns = (
	' [yY]oung',
	' [yY]outh',
	' [Dd]id [yY]ou',
	' [Dd]o [yY]ou',
	' [Aa]re [yY]ou',
	' [Yy]ou know',
	' [Yy]outube',
	);


   foreach $pattern (@gpatterns) {
	   @matches = ($sentence =~ /$pattern/g);
	   $num = $#matches + 1;
#	   print "matching ",$pattern, " and found $num\n";
	   #print "good sentence $sentence\n";
	   $totalcount += $num;
	   #if ($num > 0 ){
		   #print "found ", $num, " matches of ", $pattern,"\n";
		   #print $matches[0],$matches[1],$matches[2], "\n";
		   #}
   }
   foreach $pattern (@badpatterns) {
	   #print "matching ",$pattern, ":\n";
	   @matches = ($sentence =~ /$pattern/g);
	   $num = $#matches + 1;
	   $totalcount -= $num;
	   #if ($num > 0 ){
		   #print "found ", $num, " matches of ", $pattern,"\n";
		   #print $matches[0],$matches[1],$matches[2], "\n";
		   #}
   }
	if ($totalcount < 0){
		$totalcount = 0;
	}
   return $totalcount;
}
sub countmimicsinline {
     my ($sent,$prec,$start,$end,$prevstart,$prevend) = @_;
#     print "sent is $sent, start is $start, end is $end, prevstart is $prevstart, prevend is $prevend\n";
     my $currtotalwords = 0;
     my $mimicrawcount = 0;
     my $noyoutotalwords = 0;
     my $noyoumimiccount = 0;
     my $mimicsentnormcount = 0;
     my $mimicsentnormnoyouicount = 0;
     my $mimicswbdnormcount = 0;
     my $laughmimiccount = 0;
     my $mimicfunccount = 0;
	my $interrupt = 0;
	my $sentlaughs = 0;
	my $prevlaughs = 0;
	my $overlapcount = 0;
	my $prevtotalwords = 0;
	my $currtotalwords = 0;

   foreach $pattern (@overlappatterns) {
	   @matches = ($prec =~ /$pattern/g);
	   $num = $#matches + 1;
	   $overlapcount += $num;
   }
   # if previous sentence ends in a dash and current sentence has "[interposing]" or lots of words
   if (($overlapcount > 0) and (($sent =~ /interposing/) or ($sent =~ " .* .* .*"))){
#			    print "found an interruption: prev is $prec\n";
			    $interrupt = 1;
   }

#   print "sent is: $sent, prev is $prec\n";


   if ($sent =~ /\[laughter\]/) {
	   $sentlaughs = 1;
   }
   if ($prec =~ /\[laughter\]/) {
	   $prevlaughs = 1;
   }
   if ($sentlaughs and $prevlaughs) {
	   $laughmimiccount = 1;
   }
   #print "sent laffs is $sentlaughs; prevlaughs is $prevlaughs\n";
   $sent =~ s/\[a-zA-Z*\]//;
   $prec =~ s/\[a-zA-Z*\]//;


     $sent =~ tr/A-Z/a-z/;
     $sent =~ s/--/ /g;
     $sent =~ s/- / /g;
     $sent =~ s/ -/ /g;
     $sent =~ s/[,\.?;:!]/ /g;
     $sent =~ s/  / /g;
     $prec =~ tr/A-Z/a-z/;
     $prec =~ s/--/ /g;
     $prec =~ s/- / /g;
     $prec =~ s/ -/ /g;
     $prec =~ s/[,\.?;:!]/ /g;
     $prec =~ s/  / /g;

     $prec =~ s/\[[^][]*\]//g;
     $sent =~ s/\[[^][]*\]//g;

     $sent =~ s/  */ /g;
     $prec =~ s/  */ /g;
     $sent =~ s/^ //g;
     $sent =~ s/ $//g;
     $prec =~ s/^ //g;
     $prec =~ s/ $//g;
     # print "prec: **$prec**, sent: **$sent**\n";
     @currwords = split(/\s+/,$sent);
     @previouswords = split(/\s+/,$prec);
      $prevtotalwords = $#previouswords + 1;
     foreach $word (@currwords){
#	     print "looking at current word $word\n";
   	  $currtotalwords++;
          foreach $pword (@previouswords){
		
                if ($word eq $pword) {

		        $mimicrawcount += 1;

                        foreach $funcword (@funcwords) {
				if ($word eq $funcword) {
					$mimicfunccount++;
#		  print "mimic of a func word: *$pword*\n";
					last;
			        } 
			}

			#if ($mimicfunccount == 0) {
				# if it's a content word
		                $swbdfreq = $swbd{$word}; 
			        #print "swbd freq of *$word* is $swbdfreq\n";
			        if ($swbdfreq eq "") { 
				        $swbdfreq = 0; 
			        } 
			        $swbdfreq += .1;
			        $mimicswbdnormcount  += 1/$swbdfreq;
				$mimicsentnormcount  ++;
				if ($mimicfunccount == 0) {
#		  print "mimic of a content word: *$pword*\n";
			             $mimicswbdcontnormcount  += 1/$swbdfreq;
			        }
				#}

			#if (($word ne "you") and ($word ne "i")) {
			#$noyoumimiccount += 1;
			#}
		       #print "prev: $prevsent\n";
		       #print "curr: $currsent\n";
		       #print "$word\n";
		       last;
                  }
	  }
     }
     #if ($noyoutotalwords) {
     #$mimicsentnormnoyouicount = $noyoumimiccount / $noyoutotalwords;
     #}
     
     if ($currtotalwords) {
	     #$mimicsentnormcount = $mimicrawcount / $currtotalwords;
         $mimicswbdnormcount = $mimicswbdnormcount / $currtotalwords;
         $mimicswbdcontnormcount = $mimicswbdcontnormcount / $currtotalwords;
	 #$mimicfunccount = $mimicfunccount / $currtotalwords;
	 if ($start > $end) {
		   $time = 0.5;
	   } else {
		   $time = ($end - $start) + 0.5;
	   }
	 $rateofspeech = $currtotalwords/ $time;
	 #print "rate of speech is $currtotalwords divided by $end minus $start + .5 = $rateofspeech\n";
     }
     if ($prevtotalwords) {
	 if ($prevstart > $prevend) {
		   $prevtime = 0.5;
	   } else {
		   $prevtime = ($prevend - $prevstart) + 0.5;
	   }
	 $prevrateofspeech = $prevtotalwords/$prevtime;
	 #print "prevrate of speech is $prevtotalwords divided by $prevend minus $prevstart + .5 = $prevrateofspeech\n";
       }

 #$ratedelta = $rateofspeech-$prevrateofspeech;

 #print "returning $mimicsentnormcount,$mimicswbdnormcount,$mimicfunccount,$mimicswbdcontnormcount,$laughmimiccount,$rateofspeech,XX$prevrateofspeechXX\n";
     return ($interrupt, $mimicsentnormcount,$mimicswbdnormcount,$mimicfunccount,$mimicswbdcontnormcount,$laughmimiccount,$rateofspeech,$prevrateofspeech,$currtotalwords);
}

sub countprintvariables {
	my ($precsent,$starttime,$endtime,$prevstart,$prevend) = @_;
	$hedgecount = matchpatterninline(@hedgepatterns);
	$hatecount = matchpatterninline(@hatepatterns);
	$workcount = matchpatterninline(@workpatterns);
	$lovecount = matchpatterninline(@lovepatterns);
	$sexcount = matchpatterninline(@sexpatterns);
	$drinkcount = matchpatterninline(@drinkpatterns);
	$foodcount = matchpatterninline(@foodpatterns);
	$sympathycount = matchpatterninline(@sympathypatterns);
	$swearcount = matchpatterninline(@swearpatterns);
	$negemocount = matchpatterninline(@negemopatterns);
	$negatecount = matchpatterninline(@negatepatterns);
	$metacount = matchpatterninline(@metapatterns);
	$ntricount = matchpatterninline(@ntripatterns);
	$likecount = matchpatterninline(@likepatterns);
	$imeancount = matchpatterninline(@imeanpatterns);
	$youknowcount = matchpatterninline(@youknowpatterns);
	$apprcount = matchpatterninline(@apprpatterns);
	$agreecount = matchpatterninline(@agreepatterns);
	$umcount = matchpatterninline(@umpatterns);
	$uhcount = matchpatterninline(@uhpatterns);
	$youcount =  matchyouinline();
	$icount =  matchpatterninline(@ipatterns);
	$restartcount = matchpatterninline(@restartpatterns);
	$initlaugh = matchpatterninline(@initlaughpatterns);
	$midlaugh = matchpatterninline(@midlaughpatterns);
	$question = matchpatterninline(@questionpatterns);
        ($overlapcount, $mimicsentnormcount,$mimicswbdnormcount,$mimicfunccount,$mimicswbdcontnormcount,$laughmimiccount,$rateofspeech,$prevrateofspeech,$totalwordcount) = countmimicsinline($sentence,$precsent,$starttime,$endtime,$prevstart,$prevend);
	#print "received $mimicrawcount,$mimicsentnormcount,$mimicsentnormnoyouicount,$mimicswbdnormcount,\n";

#	print "youcount is $youcount\n";
	printf "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%f,%f,%d,%f,%f,%d,%d,%d,%d,%d,%d,%d\n",$hatecount,$workcount,$lovecount,$sexcount,$drinkcount,$foodcount,$negemocount,$swearcount,$sympathycount,$negatecount,$hedgecount,$metacount,$ntricount,$likecount,$imeancount,$youknowcount,$youcount,$apprcount,$agreecount,$restartcount,$overlapcount,$mimicsentnormcount,$mimicfunccount,$mimicswbdnormcount,$mimicswbdcontnormcount,$laughmimiccount,$rateofspeech,$prevrateofspeech,$initlaugh,$midlaugh,$totalwordcount,$icount,$uhcount,$umcount, $question;

#   print "date,speaker,turn, starttime, endtime,  hate, work, love, sex, drink, food, negemo, swear, sympathy, negate, hedge, meta, ntri, like, imean, youknow, you, appr, agree\n";
}


%
% Pakeitimai:
% ------------------------
%
% v2016.03.19.1
% + Nepavykus rayti *.set, pasilyti pamginti vl.
% + Eksperimentin pop_eeg_perira parinktis rodyti 
%   vien (perirai) arba dvi (palyginimui) rinkmen narykles.
% ~ Labiau nugludintas eeg_perira varikliukas.
% ~ Kiti smulks pakeitimai.
%
% v2016.01.25.1
% + EEG spektro raymo  TXT parinktis.
% ~ EEG spektrins galios skaiiavimo dialoge leisti 
%   interpoliavimui pasirinkti nesanius kanalus.
% + spti i naujo atveriant Darbeli lang.
% + spti atveriant kelis periros langus.
% ~ Patobulinta EEG perira senesnse MATLAB versijose.
% ~ Patobulinta epochuot ra perira, lygiuojant vykius ir nurodant laik.
% ~ Patobulinta NKA komponeni perira, leidiant 
%   grti atgal prie atmestin komponeni pasirinkimo.
% ~ Numatytuoju atveju po darb nekelti  EEGLAB.
% ~ Didesnis ir isamesnis dialogas katalogo pasirinkimui i srao.
% ~ Kiti smulks pakeitimai.
%
% v2015.11.24.1
% ~ Nuoseklaus apdorojimo lange,
%   NKA komponeni periroje, kai pasirinkta 
%   parinktis Laukti patvirtinimo (Darbeliai)
%   (beje, numatytoji yra Laukti patvirtinimo (EEGLAB)),
%   suteikti mygtukams Ne ir Priimti tinkamas funkcijas.
%
% v2015.11.21.1
% + Interpoliavus kanalus, pasirinktinai atmesti arba palikti 
%   nepasirinktuosius kanalus. Anksiau jie atmetinti.
%
% v2015.11.08.1
% ~ EEG spektrins galios skaiiavime itaisyti kanal priskyrim.
% + EEG spektrin gali pasirinktinai eksportuoti  txt:
%   absoliui, santykin, abi (numatyta).
%
% v2015.11.06.1
% ~ EEG spektrin galios dialoge veikia parinktis kanal interpoliavimui.
%
% v2015.11.05.1
% ~ Stabilesn ra perira per nuosav Darbeli funkcij.
%
% v2015.10.16.1
% + SSP grafiko raymas kiekvienam kanalui atskirai. 
% ~ Gerbti pavadinim filtro parametrus.
% ~ Vertim atnaujinimas.
%
% v2015.10.10.1
% ~ SSP savybi nustatymas ir grafinis pavaizdavimas
%   neturi sutrikti, jei kanal nerasta ar nesuderinami.
%
% v2015.10.07.1
% ~ 2015.10.05 ir 2015.10.06 versijose velta klaida, kuri
%   neleido itrinti fail juos pervadinant.
% + RRI periros lange Leisti rankiniu bdu apversti EKG.
% ~ Funkcijai exist pateikti tikslius parametrus.
%
% v2015.10.06.1
% ~ Nuosekliame apdorojime ir SSP savybi lange 
%   ijungti filtr rinkmen, atrinkimui vos tik jos
%   pradedamos ymti rankiniu bdu.
%
% v2015.10.05.1
% ~ Patobulinimai perirint ICA per nuoseklaus apdorojimo lang.
% ~ Nenulti rodant bsenos langel, kai naudojama MATLAB R2015b.
%
% v2015.09.14.1
% ~ MATLAB R2015b nerodys beprasmi praneim.
%
% v2015.09.03.1
% ~ Neepocuot EEG ra lyginimo patobulinimai.
%
% v2015.08.24.1
% ~ EEG ra periros ir lyginimo patobulinimai.
% + Nuosekliame apdorojime ir Savit komand vykdyme galima
%   vizualiai palyginti pradin ir apdorot EEG ra.
%
% v2015.08.14.1
% + Naujas rankis EEG ra perirai/palyginimui
% + leidia sklandiau naviguoti klaviatra ir pele.
%
% v2015.08.08.1
% + Kanal ir vyki pasirinkimas ne EEGLAB *.set duomenims (per BIOSIG).
% + Fail pervadinimo dialoge irgi galima greitai pasirinkti katalogus.
% ~ Nedubliuoti fail kartu rodant lygiagreius aplankus.
%
% v2015.08.02.1
% ~ Stabilesnis atnaujinimo mechanizmas.
%
% v2015.08.01.1
% + Parinki importavimas ir eksportavimas.
% + Veiksm meniu: 
%   rodyti failus i pakatalogi, virkatalogi ar lygiagrei katalog;
%   kelti  EEGLAB, perirti duomenis su EEGLAB, vykdyti paprast komand;
%   atverti katalog operacins sistemos rinkmen tvarkytuvje.
% + Meniu punktai praneimams apie klaidas: internetu ir el.patu.
%
% v2015.07.26.1
% ~ Patikimesnis pop_meta_drb parinki isaugojimas ir klimas.
%   EKG/RRI periros, QRS terpimo  EEG patobulinimai.
%
% v2015.07.24.1
% ~ Stabilesnis paleidimas ir atnaujinimas.
%
% v2015.07.09.1
% ~ EEG_spektr_galia.m tinkamai suteikia kanal etiketes.
% ~ pop_eeg_spektrine_galia.m galios periroje naudoja vairesnes 
%   spalvas kanalams ir vairesnius simbolius rinkmenoms ymti,
%   o spektro periroje  vairesnes spalvas linijoms.
% + pop_ERP_savybes.m periroje naudoja vairesnes spalvas linijoms.
% 
% v2015.07.07.1
% ~ Pagerintas suderinamumas su MATLAB R2015a.
%
% v2015.07.04.1
% + Darbeli pop_*.m galima paleisti udavus parametrus.
% + Darb tvarkytuv (pop_meta_drb.m): tvarkyti Darbeli funkcij parinki
%   rinkinius ir atlikti darbus pereinant per skirtingus Darbeli langus.
% ~ Pagerintas pop_pervadinimas stabilumas.
%
% v2015.06.28.1
% + Papildyti EEG.history pakeitus EEG.
% ~ Itaisytas EEGLAB nenuls  EEGLAB neklus
%   nauj EEG duomen po atlikt darb.
%
% v2015.06.24.1
% ~ Neitrinti EEG ir ALLEEG kintamj pakeitus Darbeli nuostatas.
%
% v2015.06.21.1
% ~ Spartusis klavias tik pirmoms 9-ioms simintoms nuostatoms.
%
% v2015.06.07.1
% + Likusiuose languose galima siminti parinktis isaugant jas
%   skirtingais pavadinimais ir vliau jas kelti arba paalinti.
%
% v2015.06.05.1
% + Nuosekliame darbe galima siminti parinktis isaugant jas
%   skirtingais pavadinimais ir vliau jas kelti arba paalinti.
%
% v2015.06.03.1
% + Atlikt darb skaitliukas remiasi poaplankki pavadinimais.
% + Nuosekliame darbe filtruojami pirmajame i dviej filtr
%   filtruojami ne visi, o tik pasirinkti kanalai.
% ~ Nuosekliame apdorojime pasirinkus vykius epochavimui i srao,
%   neatnaujino Vykdyti mygtuko bsenos.
%
% v2015.06.02.1
% + Darbini katalog pasirinkimai prisimenami netgi i naujo paleidus MATLAB.
%
% v2015.04.15.1
% + Galios spektro vaizdavimas.
%
% v2015.03.29.1
% + Atverti sukurtus tekstinius failus.
%
% v2015.03.14.1
% + Automatinis dani srities intervalo nustatymas skaiiuojant vis spektrin gali.
%
% v2015.02.25.1
% + Nuoseklus apdorojimas nenul uvrus kanal pasirinkimo interpoliavimui dialog.
%
% v2015.02.24.1
% + Eksportuojant  Ragu, EEGLAB duomen rinkinio kanalai gali bti ne i eils
%   (tvarka suvienodinama eksportuojant pagal pirmj).
%
% v2015.02.14.1
% + Galima rinktis savus kanalus atskaitos sistemai.
% + Galima nurodyti fiksuot ICA komponeni kiek.
%
% v2015.02.01.1
% + Veikia fail vidurkinimas ERP savybi periroje ir eksportavime.
%
% v2015.01.28.1
% + ERP savybi periroje fail grupavimas.
%
% v2015.01.13.1
% ~ Kanal pasirinkimas galjo neveikti, jei nebuvo diegtas SIFT priedas,
%   nes buvo naudojama io priedo statusbar funkcija; dabar i funkcija pasiskolinta.
%
% v2014.12.31.1
% + EEG speaktrins galios skaiiavimuose galima pasirinkti, ar leisti kanal interpoliavim.
% + EEG speaktrins galios skaiiavim grafiniame lange tikrinti parametr reikmes.
%
% v2014.12.08.1
% + Pradin grafin ssaja EEG spektrins galios skaiiavimui.
%
% v2014.11.20.1
% ~ Itaisyta SSP (ERP) savybi rodymo klaida, dl kurios neveik
%   vidurkinimas per failus.
% + Nauja programl pop_rankinis.m: patys galite rayti komandas,
%   kurios bus atliekamos klus pasirinktus duomenis.
% + Dauguma funkcij palaiko raidinius vykius, kanal pavadinimus su
%   tarpais ir turi iskleidiamus meniu aplankui pasirinkti.
%
% v2014.11.19.1
% + Nuosekliame apdorojime galima pasirinkti apdorotinus kanalus kai kurioms
%   funkcijoms: tinklo triukmo filtravimui, laiko atkarp atmetimui pagal
%   amplituds slenkst ir spektr, automatiniam kanal atmetimui pagal spektr, ICA.
% + atmest_pg_amplit.m gali atsivelgti ir tik  pasirinktus kanalus, nebtinai visus.
% + RRI_perziura importuoja BIOPAC ACQ.
%
% v2014.11.18.1
% ~ itaisyta v2014.11.11.1 klaida, dl kurios ta versija kartais galjo
%   nepasileisti, jei nebuvo interneto ryio.
% + Nauji papildinio poaplankiai:
%   GUIDE grafiniai objektai perkelti  fig;
%   kit moni sukurtos programos perkeltos  external.
% + RRI_perziura.m importuoja LabChart vykius, kuri pavadinimai prasideda
%   raidmis ECG arba HRV.
% + RRI_perziura.m importuoja paprastame tekstiniame faile suraytus RRI.
% ~ LabchartEventToEEGLAB pervadinta  labchartEKGevent2eeglab. Joje atsivelgiama,
%   kad visi vykiai bt i to paties bloko.
%
% v2014.11.11.1
% + Nuoiol ir Windows sistemoje veiks filter_filenames.m viraplankiuose
%   ir poaplankiuose, tad Windows naudotojai irgi gali vienu metu apdoroti
%   skirtinguose aplankuose esanius failus per nuosekl apdorojim,
%   EEG+EKG, epochavim pg. stim. ir ats., SSP savybes, eksport
%   (pvz., nurodyto ir vienu lygiu emiau esani poaplanki apdorojimui
%   tam reikia ties Rodyti rayti *.set;.\*\*.set).
% + Nuosekliame apdorojime alia aplank pasirinkimo nuspaudus v
%   galima rasti anksiau pasirinktus aplankus, viraplankius ir poaplankius.
% + RRI_perziura.m gali importuoti EKG i rinkmen, gaut eksportuojant
%   duomenis i LabChart   *.MAT. Reikia pasrinkti kalan (jei j keli).
%   ioje RRI_perziura.m versijoje vykiai neimportuojami.
% + RRI_perziura.m leidia i naujo EKG rae aptikti QRS pagal bet kur
%   QRS_detekt.m palaikom algoritm (iuo metu  vien i 4 algoritm,
%   t.y. iskyrus QRS_detekt_fMRIb.m).
% ~ Atnaujintas QRS aptikimo Pan-Tompkin algoritmas, kur realizavo Sedghamiz.
% ~ Keli smulks kosmetiniai pakeitimai.
%
% v2014.11.06.1
% + Jei aptinkamos kelios darbeli versijos  kitas versijas
%   perkels  EEGLAB deactivatedplugins aplank.
% + Jei Ragu.m nerandama aktyviuose MATLAB keliuose, tuomet
%   dar papildomai patikrinamas EEGLAB pried aplankas.
%
% v2014.11.05.1
% ~ Dabar i ties veiks parinktis pabaigus uverti lang.
% + Nuosekliame apdorojime leisti pasirinkti kanalus, kuri pavadinime yra tarpas.
% + Nuosekliame apdorojime leisti pasirinkti raidinius vykius.
%
% v2014.10.28.1
% + RRI/QRS periros lange galima vienu metu perirti ir RRI, ir EKG,
%   jei pastarasis pasirenkamas i tarp EEG kanal esani.
%
% v2014.10.27.1
% + RRI periros langas (QRS aptikimo tikrinimui).
%
% v2014.10.26.1
% + Pirmasis grafins ssajos variantas QRS terpimui  EEG.
% ~ Nepaisoma filtr fail srae esant tik vienam vienam failui,
%   nes MATLAB neleidia nepasirinkti vienintelio elemento srae.
% + Nesaugoti tui fail (kartais itai pasitaikydavo).
% + Rodoma eigos juosta keliant kanal ar vyki sra, jei klimas
%   utrunka ilgiau nei sekund;  klim galima pertraukti.
% + Nuosekliame apdorojime leisti rinktis ir nesanius kanalus 
%   tai gali praversti importuojant, kai nra galimybs greitai perirti
%   i anksto kanal.
%
% v2014.10.24.2
% ~ eksportuoti_ragu_programai.m tvarkingiau perima ALLEEG/EEG duomen
%   struktr, jei ji pateikiama besikreippiant  pai funkcij.
% ~ spjimas nuosekliame apdorojime epochavimui laiko interval
%   parinkus netelpant  jau epocuot duomen interval.
%
% v2014.10.22.1
% ~ Nuoseklus apdorojimas: itaisyta klaida, kai filtravimo veiksenai
%   naudotas ne tas kintamasis.
%
% v2014.10.19.1
% ~ Ublokuoti Vykdyti mygtuk pradjus darbus.
% ~ galinti slinkt rinkmen srae taip pat ir j apdorojimo metu.
% - Paalintas meniu punktas eksportavimui  Ragu. Tam naudokite SSP (ERP)
%   savybi programl.
% + SSP savybs: galima kelti failus po j apdorojimo.
% + SSP savybs: fail vidurkio perira (eksportavimas nepalaikomas).
% + Nuoseklus apdorojimas: laiko atkarp atmetimas pagal slekst mikrovoltais;
%   tinka aki judesi atmetimui.
%
% v2014.10.12.2
% + Ibaigta pop_ERP_savybes funkcija.
%   Ji taip pat leidia ERP eksportuoti ERP  Ragu, txt, Excel.
%
% v2014.10.09.1
% ~ Eksportavimui  Ragu buvo remiamasi EEG.filename rau,
%   bet kai kuriuose duomenyse jis tuias. Tad jei taip nutinka,
%   pavadinimas dabar kuriamas pagal EEG.setname. Jei ir jis tuias -
%   imamas eilinis numeris.
% + Nauja prorgaml pop_ERP_savybes ERP savybms perirti
%   (versija neubaigta).
%
% v2014.09.29.2
% + Nuosekliame apdorojime: galimyb pasirinkti btent tuos
%   kanalus ir vykius, kurie yra pasirinktuose failuose.
% + Nuosekliame apdorojime: schemos pasirinkimas nustatant kanal padtis.
% + Nuosekliame apdorojime ir Epochavime pg stim ir ats:
%   galima kelti failus i skirting poaplanki. Tam  fail
%   rodymo filtr raykite .\*\*.set;*.cnt (Windows sistemai)
%   arba ./*/*.set;*.cnt (Unix: Linux, MAC sistemoms) be kabui.
%
% v2014.09.28.5
% + Epochavimas pg stim ir ats: galimyb pasirinkti btent tuos
%   vykius, kurie yra pasirinktuose failuose.
%
% v2014.09.28.1
% + pervadinimas.m: tikrinimas, ar failas jau yra.
% + pervadinimas.m: parinktis ar leisti perrayti failus.
% + pervadinimas.m ir nuoseklus_darbas.m: nuo iol
%   nepriklausomos nuo MATLAB darbinio kelio pasikeitim.
%
% v2014.09.27.1
% ~ Darbeli meniu aktyvus ir tuomet kai kelta daug ra (STUDY).
% + Pervadinime su info atnaujinimu nauja parinktis: ar
%   pervadinti/perkelti failus (paalinti originalius failus),
%   ar juos kopijuoti (palikti originalius failus).
% + Nuoseklus_apdorojimas: du kartus galima pasirinkti filtravimo
%   tip: nufiltruoti emesnius, auktesnius danius arba abu i karto.
%
% v2014.09.25.1
% + Numatytuoju atveju papildinys bando atsinaujinti pats.
% ~ Kosmetiniai pakeitimai, kad dialogai tilpt maesniuose ekranuose.
%
% v2014.09.22.1
% + Lokalizavimo galimyb
% + Papildinio nuostatos atnaujinim paiekai ir kalbos pasirinkimui
% ~ itaisyta pop_erp_area.m klaida, dl kurios funcija
%   veik tik su vienu EEG duomen rinkiniu
%
% v2014.08.29.1
% + Pervadinant failus galima panaudoti sen informacij:
%   tiriamojo kod, grup, tyrimo slyg ir sesij.
%
% v2014.08.28.3
% + Praneimas apie atnaujinim
%
% v2014.08.27.2
% + ERP vidutins amplituds radimas
%
% v2014.08.27.1
% + ERP minimum ir maksimum radimas
%
% v2014.08.26.3
% + Funkcijos ERP plotui ir x reikmei ties puse ploto rasti.
%
% v2014.08.26.2
% + Eksportavimas  Ragu program veiks ir kai paymta EEGLAB
%   parinktis keep at most one dataset in memory.
% + Po eksportavmo  Ragu, atverti santrauk.
% + Eksportuojant Ragu programai, kanal padtis ir informacin
%   fail rayti  atskir aplank.
%
% v2014.08.26.1
% ~ Eksportuojant duomenis Ragu programai ERP, eksporuoti vidurk
%
% v2014.08.25.1
% ~ Epochavimo pagal stimulus ir atsakus dialogo langas
%   dabar panaus  nuoseklaus apdorojimo dialogo lang.
%
% v2014.08.22.5
% + io papildinio parsiuntimas ir diegimas.
% ~ Veikia epochuot duomen epochavimas per nuoseklus darbas.
% ~ nieko nepaymti nuosekliam apdorojimui.
% ~ epochuojant pg. stimulus ir atsakus veikia baseline alinimas.
%
% v2014.08.21.1
% + RAGU diegimo/atnaujinimo funkcija.
% + Eksportuojat EEG duomenis ragu programai  *.TXT:
%   pagerintas duomen suderinamumo tikrinimas, kartu
%   eksportuojamas ir atitinkamas kanal idstymas  MAT.
% + Nuoseklus apdorojimas: galimyb atrinkti raus, kuriuose
%   raai btinai yra su visais nurodytais kanalais.
%
% v2014.08.19.1
% + Nauja meniu f-ja: ra eksportavimas  *.TXT RAGU programai.
% ~ Pagerintas veikimas esant skirtingoms koduotms.
% ~ Itaisytas ra vienodinimas: anksiau buvo paliekami per trumpi raai.
%
% v2014.08.18.1
% ~ itaisytas "pervadinimas.m": anksciau nepasileisdavo, jei
%   darbiniame kataloge nebuvo fail
%
% v2014.07.25.3
% ~ itaisytas epochavimas, nebaigt ra paymjimas po
%   darb (jei praoma nutraukti anksiau)
%
% v2014.07.25.2
% ~ epochochavimas pagal stimulus ir atsakus palieka tarpinius failus
%
% v2014.07.25.1
% + pervadinimas su info atnaujinimu
%
% v2014.07.21
% ~ nuoseklus apdorojimas v0.2

function darbeliu_istorija
doc darbeliu_istorija

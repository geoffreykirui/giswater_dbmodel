/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- drop constraints

INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('pipecat_vdefault', 'FC110-PN10', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('psector_measurement_vdefault', '1', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('tankcat_vdefault', 'TANK_01', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('hydrantcat_vdefault', 'HYDRANT 1X110', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('junctioncat_vdefault', 'JUNCTION DN110', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('pumpcat_vdefault', 'PUMP-01', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('valvecat_vdefault', 'AIR VALVE DN50', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('metercat_vdefault', 'PRESSUREMETERDN110 PN16', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('sourcecat_vdefault', 'SOURCE-01', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('filtercat_vdefault', 'FILTER-01-DN200', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('registercat_vdefault', 'REGISTER', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('netwjoincat_vdefault', 'WATER-CONNECTION', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('expansiontankcat_vdefault', 'EXPANTANK', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('flexuioncat_vdefault', 'FLEXUNION', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('netelementcat_vdefault', 'NETELEMENT', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('netsamplepointcat_vdefault', 'NETSAMPLEPOINT', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('greentapcat_vdefault', 'PVC50-PN16-GRE', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('wjoincat_vdefault', 'PVC25-PN16-DOM', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('fountaincat_vdefault', 'PVC63-PN16-FOU', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('tapcat_vdefault', 'PVC25-PN16-TAP', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('psector_scale_vdefault', '2.00', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('psector_rotation_vdefault', '0.0000', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('psector_gexpenses_vdefault', '19.00', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('psector_vat_vdefault', '21.00', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('psector_type_vdefault', '1', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('psector_other_vdefault', '4.00', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('presszone_vdefault', '3', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('flexunioncat_vdefault', 'FLEXUNION', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('arccat_vdefault', 'FC110-PN10', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('state_vdefault', '1', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('workcat_vdefault', 'work1', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('verified_vdefault', 'VERIFIED', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('connecat_vdefault', 'PVC25-PN16-DOM', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('nodecat_vdefault', 'AIR VALVE DN50', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('pavementcat_vdefault', 'Asphalt', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('elementcat_vdefault', 'COVER', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('soilcat_vdefault', 'soil1', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('statetype_vdefault', '2', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('ownercat_vdefault', 'owner1', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('wtpcat_vdefault', 'ETAP', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('psector_vdefault', '1', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('cad_tools_base_layer_vdefault', 'Streetaxis', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('dim_tooltip', 'false', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('qgis_template_folder_path', NULL, current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_arc_downgrade_force', 'FALSE', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_arc_division_dsbl', 'FALSE', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('plan_arc_vdivision_dsbl', 'FALSE', current_user);
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('statetype_plan_vdefault', 3, current_user);


-- insert mandatory values
INSERT INTO config_param_user (parameter, value, cur_user)
		SELECT sys_param_user.id, vdefault, current_user FROM config_param_user RIGHT JOIN sys_param_user ON sys_param_user.id=parameter 
		WHERE ismandatory IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE pg_has_role(current_user, oid, 'member')) ON CONFLICT (parameter, cur_user) DO NOTHING;



INSERT INTO macroexploitation VALUES (1, 'Macroexploitation-1', 'Macroexploitation-1', NULL);

INSERT INTO exploitation VALUES (1, 'expl_01', 1, NULL, NULL, '0106000020E764000001000000010300000001000000310000004344FB8D57901941579E3EEE847551414952F8205C901941B8E002D4967551412BEA86DD5E901941F1B6390E9D7551413CD9D0716790194146526D5EA2755141C252A53388901941664752E5A675514191608F1EC4901941107C78DAAA755141CD78F02601911941C9594B57AD7551414B4A73286091194199E45D54AF75514196093983DB9119419860ED49B175514149511D00F9911941A04440BDAF755141B5BE46E8AD921941115C602EA47551413252FCBE16941941AC9DABDF94755141C78F577EA29419415AE606D58E755141FCEF873869951941DBF98480867551414E302882CF95194168805EE581755141F6C32938F4961941D22EAC8E75755141BEF2646F3C9719414D0EBC8972755141B8A7F68B9A971941C8CDBE026E755141B22277D1FD97194193B3528968755141A8344C506D981941BC3C94776275514160A9766BB2981941E2E516F45E755141CA43B6C34F991941615273F3557551410137653BB1991941816A8CAD50755141B0C634E3339A1941036077F54A755141BE58D480839A1941224D3F97477551410BFAD15B709B1941806778B53D755141C2A48EBD199C19410F36E0BE367551419E9C3986F39B19416CBC9C1C33755141EAE67282AE9B1941FBE7A8EA3575514124193708FA9A1941AC2FF50B2C75514107D9C6CECB9A194101574A97297551414723F9E6179A19412C13ABA61F755141CAB0FBC0ED991941446A39E61C755141309C88F89098194121ABAC8A087551411D554E735E98194151FB59B705755141962F594D3D9819415F273EE5037551410EC2A5985A971941C7A4626AF77451416E6AC5DC6F961941F6EF74CCEA745141D6D7D6B2959519417289B548EF745141BEEC10BC4995194190769F9CF07451415C5A0852729419413182684F02755141DCE1D4EF6B94194131C106B705755141F1E448C7A1931941A4154AA615755141D1BA81A24E9319415BFD9E7E1975514154BF5362D4911941BB61D7152975514169EECA68629019410ED2733838755141CEE8BC0E43901941490775783A755141253AB8DB34901941CEE66D84407551414344FB8D57901941579E3EEE84755141', '2017-12-22 12:30:52.569543');
INSERT INTO exploitation VALUES (2, 'expl_02', 1, NULL, NULL, '0106000020E76400000100000001030000000100000020000000BBD70605668A1941BEB94A87BF765141584CD18B848919412D294EC3B57651411A1991F0AE881941D9ED61A0AB76514113D980EEA3871941BAB108279E7651418474A44FDB871941D13E8274997651410A7D84E9FE8719412ECCCADE957651417CD969941C881941B20229FB8B765141736CAD5B3088194158565FEF84765141E5C892064E88194185AA331D80765141380CC18979881941F15318EC7A7651416C3638E5B28819416C19991F74765141EDD15B46EA8819416A34F9106E76514186197A96278919413FC1A341687651410548E1BE72891941F8DB3416617651411213A8BBF98919415DF5BA5A5476514133A1A8E86F8A194150BA9D544B765141CC0E4EC7D48A1941CA7F1E8844765141F5F18F78498B1941BA7EE2144076514121AF4A9B968B1941E3F137E445765141CB473921268D1941F5F273574A765141A02F5445258E1941692CB7B04C765141DAFDCE9BB98E1941849ED00C4E76514132DC37DAA38E19418C2E2F9755765141DF980957788E194172C036EB64765141061F7DB7568E1941788A760871765141828359561F8E1941C339255184765141A5374B39D08D194174EB1A9DA1765141115DE9217F8D1941ECF2BEC3C076514134E35C825D8D19414276DAABCE76514132074079A28B1941F4821D4EC87651412191BA001A8B1941531066B8C4765141BBD70605668A1941BEB94A87BF765141', '2018-01-22 14:30:19.434152');

INSERT INTO macrodma VALUES (1, 'macrodma_01', 1, NULL, NULL, '0106000020E764000001000000010300000001000000310000004344FB8D57901941579E3EEE847551414952F8205C901941B8E002D4967551412BEA86DD5E901941F1B6390E9D7551413CD9D0716790194146526D5EA2755141C252A53388901941664752E5A675514191608F1EC4901941107C78DAAA755141CD78F02601911941C9594B57AD7551414B4A73286091194199E45D54AF75514196093983DB9119419860ED49B175514149511D00F9911941A04440BDAF755141B5BE46E8AD921941115C602EA47551413252FCBE16941941AC9DABDF94755141C78F577EA29419415AE606D58E755141FCEF873869951941DBF98480867551414E302882CF95194168805EE581755141F6C32938F4961941D22EAC8E75755141BEF2646F3C9719414D0EBC8972755141B8A7F68B9A971941C8CDBE026E755141B22277D1FD97194193B3528968755141A8344C506D981941BC3C94776275514160A9766BB2981941E2E516F45E755141CA43B6C34F991941615273F3557551410137653BB1991941816A8CAD50755141B0C634E3339A1941036077F54A755141BE58D480839A1941224D3F97477551410BFAD15B709B1941806778B53D755141C2A48EBD199C19410F36E0BE367551419E9C3986F39B19416CBC9C1C33755141EAE67282AE9B1941FBE7A8EA3575514124193708FA9A1941AC2FF50B2C75514107D9C6CECB9A194101574A97297551414723F9E6179A19412C13ABA61F755141CAB0FBC0ED991941446A39E61C755141309C88F89098194121ABAC8A087551411D554E735E98194151FB59B705755141962F594D3D9819415F273EE5037551410EC2A5985A971941C7A4626AF77451416E6AC5DC6F961941F6EF74CCEA745141D6D7D6B2959519417289B548EF745141BEEC10BC4995194190769F9CF07451415C5A0852729419413182684F02755141DCE1D4EF6B94194131C106B705755141F1E448C7A1931941A4154AA615755141D1BA81A24E9319415BFD9E7E1975514154BF5362D4911941BB61D7152975514169EECA68629019410ED2733838755141CEE8BC0E43901941490775783A755141253AB8DB34901941CEE66D84407551414344FB8D57901941579E3EEE84755141');
INSERT INTO macrodma VALUES (2, 'macrodma_02', 2, NULL, NULL, '0106000020E7640000010000000103000000010000002000000032074079A28B1941F4821D4EC8765141BBD70605668A1941BEB94A87BF765141584CD18B848919412D294EC3B57651411A1991F0AE881941D9ED61A0AB76514113D980EEA3871941BAB108279E7651418474A44FDB871941D13E8274997651410A7D84E9FE8719412ECCCADE957651417CD969941C881941B20229FB8B765141736CAD5B3088194158565FEF84765141E5C892064E88194185AA331D80765141380CC18979881941F15318EC7A7651416C3638E5B28819416C19991F74765141EDD15B46EA8819416A34F9106E7651410548E1BE72891941F8DB3416617651411213A8BBF98919415DF5BA5A5476514133A1A8E86F8A194150BA9D544B765141CC0E4EC7D48A1941CA7F1E8844765141F5F18F78498B1941BA7EE2144076514121AF4A9B968B1941E3F137E4457651416E7F8844AA8C1941818B7CEF48765141CB473921268D1941F5F273574A765141DAFDCE9BB98E1941849ED00C4E765141DF980957788E194172C036EB64765141061F7DB7568E1941788A760871765141828359561F8E1941C3392551847651417CC8161ADB8D19416EA3EBD79D765141EFBF3680B78D19418DDF4451AB765141776351D5998D1941221B0091B6765141115DE9217F8D1941ECF2BEC3C076514134E35C825D8D19414276DAABCE7651411F0812C5938C194137205DB4CB76514132074079A28B1941F4821D4EC8765141');

INSERT INTO dma VALUES (2, 'dma_01', 1, NULL, NULL, NULL, '0106000020E764000001000000010300000001000000310000004344FB8D57901941579E3EEE847551414952F8205C901941B8E002D4967551412BEA86DD5E901941F1B6390E9D7551413CD9D0716790194146526D5EA2755141C252A53388901941664752E5A675514191608F1EC4901941107C78DAAA755141CD78F02601911941C9594B57AD7551414B4A73286091194199E45D54AF75514196093983DB9119419860ED49B175514149511D00F9911941A04440BDAF755141B5BE46E8AD921941115C602EA47551413252FCBE16941941AC9DABDF94755141C78F577EA29419415AE606D58E755141FCEF873869951941DBF98480867551414E302882CF95194168805EE581755141F6C32938F4961941D22EAC8E75755141BEF2646F3C9719414D0EBC8972755141B8A7F68B9A971941C8CDBE026E755141B22277D1FD97194193B3528968755141A8344C506D981941BC3C94776275514160A9766BB2981941E2E516F45E755141CA43B6C34F991941615273F3557551410137653BB1991941816A8CAD50755141B0C634E3339A1941036077F54A755141BE58D480839A1941224D3F97477551410BFAD15B709B1941806778B53D755141C2A48EBD199C19410F36E0BE367551419E9C3986F39B19416CBC9C1C33755141EAE67282AE9B1941FBE7A8EA3575514124193708FA9A1941AC2FF50B2C75514107D9C6CECB9A194101574A97297551414723F9E6179A19412C13ABA61F755141CAB0FBC0ED991941446A39E61C755141309C88F89098194121ABAC8A087551411D554E735E98194151FB59B705755141962F594D3D9819415F273EE5037551410EC2A5985A971941C7A4626AF77451416E6AC5DC6F961941F6EF74CCEA745141D6D7D6B2959519417289B548EF745141BEEC10BC4995194190769F9CF07451415C5A0852729419413182684F02755141DCE1D4EF6B94194131C106B705755141F1E448C7A1931941A4154AA615755141D1BA81A24E9319415BFD9E7E1975514154BF5362D4911941BB61D7152975514169EECA68629019410ED2733838755141CEE8BC0E43901941490775783A755141253AB8DB34901941CEE66D84407551414344FB8D57901941579E3EEE84755141');
INSERT INTO dma VALUES (3, 'dma_02', 2, NULL, NULL, NULL, '0106000020E7640000010000000103000000010000001F000000BBD70605668A1941BEB94A87BF765141584CD18B848919412D294EC3B57651411A1991F0AE881941D9ED61A0AB76514113D980EEA3871941BAB108279E7651418474A44FDB871941D13E8274997651410A7D84E9FE8719412ECCCADE957651417CD969941C881941B20229FB8B765141736CAD5B3088194158565FEF84765141E5C892064E88194185AA331D80765141380CC18979881941F15318EC7A7651416C3638E5B28819416C19991F74765141EDD15B46EA8819416A34F9106E76514186197A96278919413FC1A341687651410548E1BE72891941F8DB3416617651411213A8BBF98919415DF5BA5A5476514133A1A8E86F8A194150BA9D544B765141CC0E4EC7D48A1941CA7F1E8844765141F5F18F78498B1941BA7EE2144076514121AF4A9B968B1941E3F137E445765141CB473921268D1941F5F273574A765141014432FA8C8D19416281F8344B765141DAFDCE9BB98E1941849ED00C4E76514132DC37DAA38E19418C2E2F9755765141DF980957788E194172C036EB64765141061F7DB7568E1941788A760871765141828359561F8E1941C339255184765141A5374B39D08D194174EB1A9DA1765141115DE9217F8D1941ECF2BEC3C076514134E35C825D8D19414276DAABCE76514132074079A28B1941F4821D4EC8765141BBD70605668A1941BEB94A87BF765141');

INSERT INTO macrosector VALUES (1, 'macrosector_01','macrosector_project_ud', NULL, '0106000020E764000001000000010300000001000000310000004344FB8D57901941579E3EEE847551414952F8205C901941B8E002D4967551412BEA86DD5E901941F1B6390E9D7551413CD9D0716790194146526D5EA2755141C252A53388901941664752E5A675514191608F1EC4901941107C78DAAA755141CD78F02601911941C9594B57AD7551414B4A73286091194199E45D54AF75514196093983DB9119419860ED49B175514149511D00F9911941A04440BDAF755141B5BE46E8AD921941115C602EA47551413252FCBE16941941AC9DABDF94755141C78F577EA29419415AE606D58E755141FCEF873869951941DBF98480867551414E302882CF95194168805EE581755141F6C32938F4961941D22EAC8E75755141BEF2646F3C9719414D0EBC8972755141B8A7F68B9A971941C8CDBE026E755141B22277D1FD97194193B3528968755141A8344C506D981941BC3C94776275514160A9766BB2981941E2E516F45E755141CA43B6C34F991941615273F3557551410137653BB1991941816A8CAD50755141B0C634E3339A1941036077F54A755141BE58D480839A1941224D3F97477551410BFAD15B709B1941806778B53D755141C2A48EBD199C19410F36E0BE367551419E9C3986F39B19416CBC9C1C33755141EAE67282AE9B1941FBE7A8EA3575514124193708FA9A1941AC2FF50B2C75514107D9C6CECB9A194101574A97297551414723F9E6179A19412C13ABA61F755141CAB0FBC0ED991941446A39E61C755141309C88F89098194121ABAC8A087551411D554E735E98194151FB59B705755141962F594D3D9819415F273EE5037551410EC2A5985A971941C7A4626AF77451416E6AC5DC6F961941F6EF74CCEA745141D6D7D6B2959519417289B548EF745141BEEC10BC4995194190769F9CF07451415C5A0852729419413182684F02755141DCE1D4EF6B94194131C106B705755141F1E448C7A1931941A4154AA615755141D1BA81A24E9319415BFD9E7E1975514154BF5362D4911941BB61D7152975514169EECA68629019410ED2733838755141CEE8BC0E43901941490775783A755141253AB8DB34901941CEE66D84407551414344FB8D57901941579E3EEE84755141');
INSERT INTO macrosector VALUES (2, 'macrosector_02','macrosector_project_ud', NULL, '0106000020E76400000100000001030000000100000020000000F645AAE0958D1941CBF046DDB776514134E35C825D8D19414276DAABCE76514132074079A28B1941F4821D4EC8765141BBD70605668A1941BEB94A87BF765141584CD18B848919412D294EC3B57651411A1991F0AE881941D9ED61A0AB7651419CF220BC0E881941217A6E97A376514113D980EEA3871941BAB108279E7651418474A44FDB871941D13E8274997651410A7D84E9FE8719412ECCCADE95765141736CAD5B3088194158565FEF84765141E5C892064E88194185AA331D80765141380CC18979881941F15318EC7A7651416C3638E5B28819416C19991F74765141EDD15B46EA8819416A34F9106E76514186197A96278919413FC1A341687651410548E1BE72891941F8DB3416617651411213A8BBF98919415DF5BA5A5476514133A1A8E86F8A194150BA9D544B765141CC0E4EC7D48A1941CA7F1E8844765141F5F18F78498B1941BA7EE2144076514121AF4A9B968B1941E3F137E445765141CB473921268D1941F5F273574A765141A02F5445258E1941692CB7B04C765141DAFDCE9BB98E1941849ED00C4E76514132DC37DAA38E19418C2E2F9755765141670EA629888E19417886555860765141061F7DB7568E1941788A760871765141828359561F8E1941C339255184765141AAB5C7A5038E194154CA21158E765141A5374B39D08D194174EB1A9DA1765141F645AAE0958D1941CBF046DDB7765141');

INSERT INTO sector VALUES (2, 'sector_01', 1, 'sector_sample_epanet', NULL, '0106000020E764000001000000010300000001000000310000004344FB8D57901941579E3EEE847551414952F8205C901941B8E002D4967551412BEA86DD5E901941F1B6390E9D7551413CD9D0716790194146526D5EA2755141C252A53388901941664752E5A675514191608F1EC4901941107C78DAAA755141CD78F02601911941C9594B57AD7551414B4A73286091194199E45D54AF75514196093983DB9119419860ED49B175514149511D00F9911941A04440BDAF755141B5BE46E8AD921941115C602EA47551413252FCBE16941941AC9DABDF94755141C78F577EA29419415AE606D58E755141FCEF873869951941DBF98480867551414E302882CF95194168805EE581755141F6C32938F4961941D22EAC8E75755141BEF2646F3C9719414D0EBC8972755141B8A7F68B9A971941C8CDBE026E755141B22277D1FD97194193B3528968755141A8344C506D981941BC3C94776275514160A9766BB2981941E2E516F45E755141CA43B6C34F991941615273F3557551410137653BB1991941816A8CAD50755141B0C634E3339A1941036077F54A755141BE58D480839A1941224D3F97477551410BFAD15B709B1941806778B53D755141C2A48EBD199C19410F36E0BE367551419E9C3986F39B19416CBC9C1C33755141EAE67282AE9B1941FBE7A8EA3575514124193708FA9A1941AC2FF50B2C75514107D9C6CECB9A194101574A97297551414723F9E6179A19412C13ABA61F755141CAB0FBC0ED991941446A39E61C755141309C88F89098194121ABAC8A087551411D554E735E98194151FB59B705755141962F594D3D9819415F273EE5037551410EC2A5985A971941C7A4626AF77451416E6AC5DC6F961941F6EF74CCEA745141D6D7D6B2959519417289B548EF745141BEEC10BC4995194190769F9CF07451415C5A0852729419413182684F02755141DCE1D4EF6B94194131C106B705755141F1E448C7A1931941A4154AA615755141D1BA81A24E9319415BFD9E7E1975514154BF5362D4911941BB61D7152975514169EECA68629019410ED2733838755141CEE8BC0E43901941490775783A755141253AB8DB34901941CEE66D84407551414344FB8D57901941579E3EEE84755141');
INSERT INTO sector VALUES (3, 'sector_02', 2, 'sector_2_sample_epanet', NULL, '0106000020E76400000100000001030000000100000020000000F645AAE0958D1941CBF046DDB776514134E35C825D8D19414276DAABCE76514132074079A28B1941F4821D4EC8765141BBD70605668A1941BEB94A87BF765141584CD18B848919412D294EC3B57651411A1991F0AE881941D9ED61A0AB7651419CF220BC0E881941217A6E97A376514113D980EEA3871941BAB108279E7651418474A44FDB871941D13E8274997651410A7D84E9FE8719412ECCCADE95765141736CAD5B3088194158565FEF84765141E5C892064E88194185AA331D80765141380CC18979881941F15318EC7A7651416C3638E5B28819416C19991F74765141EDD15B46EA8819416A34F9106E76514186197A96278919413FC1A341687651410548E1BE72891941F8DB3416617651411213A8BBF98919415DF5BA5A5476514133A1A8E86F8A194150BA9D544B765141CC0E4EC7D48A1941CA7F1E8844765141F5F18F78498B1941BA7EE2144076514121AF4A9B968B1941E3F137E445765141CB473921268D1941F5F273574A765141A02F5445258E1941692CB7B04C765141DAFDCE9BB98E1941849ED00C4E76514132DC37DAA38E19418C2E2F9755765141670EA629888E19417886555860765141061F7DB7568E1941788A760871765141828359561F8E1941C339255184765141AAB5C7A5038E194154CA21158E765141A5374B39D08D194174EB1A9DA1765141F645AAE0958D1941CBF046DDB7765141');

INSERT INTO plan_psector (psector_id, name, psector_type, descript, expl_id, priority, text1, text2, observ, rotation, scale, sector_id, atlas_id, gexpenses, vat, other, active, the_geom, status) 
VALUES (2, 'Masterplan 02', 1, 'Expanding the capacity of the pipes located on Legalitat street.', 1, 'LOW_PRIORITY', NULL, NULL, 'Action caused by the headloss of the pipe.', 90.0000, 750.00, 2, '02', 19.00, 21.00, 0.00, true, '0106000020E76400000100000001030000000100000005000000381DD4A516941941573C70AA91755141381DD4A5169419414F030E2380755141926E3B4B559319414F030E2380755141926E3B4B55931941573C70AA91755141381DD4A516941941573C70AA91755141',2);

INSERT INTO plan_psector (psector_id, name, psector_type, descript, expl_id, priority, text1, text2, observ, rotation, scale, sector_id, atlas_id, gexpenses, vat, other, active, the_geom, status)
VALUES (1, 'Masterplan 01', 1, 'Expanding the capacity of the pipes located on Francesc Layret street.', 1, 'NORMAL_PRIORITY', NULL, NULL, 'Action caused by the headloss of the pipe.', 0.0000, 750.00, 2, '01', 19.00, 21.00, 0.00, true, '0106000020E76400000100000001030000000100000005000000DF7F8D6B26961941FB72887B42755141DF7F8D6B269619412117DBD63D7551411988DCCE469419412117DBD63D7551411988DCCE46941941FB72887B42755141DF7F8D6B26961941FB72887B42755141',2);



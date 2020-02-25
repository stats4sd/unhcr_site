UPDATE indicators SET subgroup_name = 'IDPs' WHERE group_name = 'IDPs' ; 
UPDATE indicators SET subgroup_name = 'in camps or settlements' WHERE group_name = 'IDPs (in camps or settlements)' ; 
UPDATE indicators SET subgroup_name = 'not in camp or settlements' WHERE group_name = 'IDPs (not in camp or settlements)' ;
UPDATE indicators SET subgroup_name = 'Mixed' WHERE group_name = 'Mixed' ;
UPDATE indicators SET subgroup_name = 'Refugees' WHERE group_name = 'Refugees' ;
UPDATE indicators SET subgroup_name = 'Asylum Seekers' WHERE group_name = 'Asylum Seekers' ;

INSERT INTO groups (name) VALUE ('Other');
INSERT INTO subgroups (name) VALUE ('IDPs');
INSERT INTO subgroups (name) VALUE ('in camps or settlements');
INSERT INTO subgroups (name) VALUE ('not in camp or settlements');
INSERT INTO subgroups (name) VALUE ('Mixed');
INSERT INTO subgroups (name) VALUE ('Refugees');
INSERT INTO subgroups (name) VALUE ('Asylum Seekers');

UPDATE indicators SET group_name = 'IDPs' WHERE subgroup_name = 'in camps or settlements' ;
UPDATE indicators SET group_name = 'IDPs' WHERE subgroup_name = 'not in camp or settlements' ;
UPDATE indicators SET group_name = 'Other' WHERE subgroup_name = 'Mixed' ;
UPDATE indicators SET group_name = 'Other' WHERE subgroup_name = 'Asylum Seekers' ;

DELETE FROM groups WHERE name = 'Mixed' ;
DELETE FROM groups WHERE name = 'Asylum Seekers' ;
DELETE FROM groups WHERE name = 'IDPs (in camps or settlements)' ;
DELETE FROM groups WHERE name = 'IDPs (not in camp or settlements)' ;
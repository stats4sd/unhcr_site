UPDATE indicators SET subgroup_name = 'No location specified' WHERE group_name = 'IDPs' ; 
UPDATE indicators SET subgroup_name = 'In camp' WHERE group_name = 'IDPs (in camps or settlements)' ; 
UPDATE indicators SET subgroup_name = 'Not in camp' WHERE group_name = 'IDPs (not in camp or settlements)' ;
UPDATE indicators SET subgroup_name = 'Forcibly displaced status not specified' WHERE group_name = 'Mixed' ;
UPDATE indicators SET subgroup_name = 'No location specified' WHERE group_name = 'Refugees' ;
UPDATE indicators SET subgroup_name = 'Asylum Seekers' WHERE group_name = 'Asylum Seekers' ;

INSERT INTO groups (name) VALUE ('Other');

INSERT INTO subgroups (name) VALUE ('In camp');
INSERT INTO subgroups (name) VALUE ('Not in camp');
INSERT INTO subgroups (name) VALUE ('No location specified');
INSERT INTO subgroups (name) VALUE ('Forcibly displaced status not specified');
INSERT INTO subgroups (name) VALUE ('Asylum Seekers');

UPDATE indicators SET group_name = 'IDPs' WHERE subgroup_name = 'In camp' ;
UPDATE indicators SET group_name = 'IDPs' WHERE subgroup_name = 'Not in camp' ;
UPDATE indicators SET group_name = 'Other' WHERE subgroup_name = 'Forcibly displaced status not specified' ;
UPDATE indicators SET group_name = 'Other' WHERE subgroup_name = 'Asylum Seekers' ;

DELETE FROM groups WHERE name = 'Mixed' ;
DELETE FROM groups WHERE name = 'Asylum Seekers' ;
DELETE FROM groups WHERE name = 'IDPs (in camps or settlements)' ;
DELETE FROM groups WHERE name = 'IDPs (not in camp or settlements)' ;
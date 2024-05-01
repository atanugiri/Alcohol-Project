% function test(varargin)

loadFile = load('boost_alcohol_animals.mat');
animals = loadFile.ans;

animalList = strjoin(animals, "','");
animal_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE subjectid IN ('%s') " + ...
    "AND health = 'N/A' AND REPLACE(tasktypedone, ' ', '') = 'P2L1' ORDER BY id", ...
    animalsList);
animal_Data = fetch(conn, animal_Q);

for i = 2:size(animal_Data, 2)
    animal_Data.(i) = string(animal_Data.(i));
end

animal_Data.referencetime = datetime(animal_Data.referencetime, 'Format', 'MM/dd/uuuu');
animal_Data.referencetime = string(animal_Data.referencetime);
unique(animal_Data.referencetime);
% end
function printTableSummary(myTable)

myTable.referencetime = datetime(myTable.referencetime, "Format","MM/dd/uuuu");
% For testing
for col = 2:size(myTable,2)
    myTable.(col) = string(myTable.(col));
end

fprintf('\n %s:\n\n', inputname(1));
tmpTable = myTable(lower(myTable.gender) == 'male', :);
fprintf("Male Animals:\n")
fprintf('n = %d.\t', length(unique(tmpTable.subjectid)));
fprintf('%s, ', unique(tmpTable.subjectid));
fprintf('\n');
fprintf("Male Dates:\n")
fprintf('%s, ', unique(tmpTable.referencetime));
fprintf('\n');

tmpTable = myTable(lower(myTable.gender) == 'female', :);
fprintf("Female Animals:\n")
fprintf('n = %d.\t', length(unique(tmpTable.subjectid)));
fprintf('%s, ', unique(tmpTable.subjectid));
fprintf('\n');
fprintf("Female Dates:\n")
fprintf('%s, ', unique(tmpTable.referencetime));
fprintf('\n');

end
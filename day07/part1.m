% READING FILE
content = fileread('problem.txt');
data = splitlines(content);

% PARSING
hands_strings=string(data);
new_hands_strings=split(hands_strings," ");
hands=new_hands_strings(:,1);
scores=new_hands_strings(:,2);
% disp(hands);
% disp(scores);

% SOLVING
% reordering
for index_i=1:length(hands)
    for index_j=(index_i+1):length(hands)
        hand1=hands(index_i);
        hand2=hands(index_j);
        if isBetter(hand1,hand2)==1
            hands(index_i)=hand2;
            hands(index_j)=hand1;
            temp=scores(index_i);
            scores(index_i)=scores(index_j);
            scores(index_j)=temp;
        end
    end
end

% computing solution value
solution=0;
for index_i=1:length(scores)
    current_score=index_i*str2num(scores(index_i));
    solution=solution+current_score;
end
disp(solution)
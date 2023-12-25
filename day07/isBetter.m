function [resultIsBetter] = isBetter(hand1,hand2)
%FUNCTION1 compare two hands to decide which one is stronger
values1=zeros(1,13);
values2=zeros(1,13);

hand1_vec=char(hand1)+0;
hand2_vec=char(hand2)+0;

for index=1:length(hand1_vec)
    value1=hand1_vec(index);
    value2=hand2_vec(index);
    
    switch value1
        case '2'
            values1(1)=values1(1)+1;
        case '3'
            values1(2)=values1(2)+1;
        case '4'
            values1(3)=values1(3)+1;
        case '5'
            values1(4)=values1(4)+1;
        case '6'
            values1(5)=values1(5)+1;
        case '7'
            values1(6)=values1(6)+1;
        case '8'
            values1(7)=values1(7)+1;
        case '9'
            values1(8)=values1(8)+1;
        case 'T'
            values1(9)=values1(9)+1;
        case 'J'
            values1(10)=values1(10)+1;
        case 'Q'
            values1(11)=values1(11)+1;
        case 'K'
            values1(12)=values1(12)+1;
        case 'A'
            values1(13)=values1(13)+1;
        otherwise
            disp('error value')
    end

    switch value2
        case '2'
            values2(1)=values2(1)+1;
        case '3'
            values2(2)=values2(2)+1;
        case '4'
            values2(3)=values2(3)+1;
        case '5'
            values2(4)=values2(4)+1;
        case '6'
            values2(5)=values2(5)+1;
        case '7'
            values2(6)=values2(6)+1;
        case '8'
            values2(7)=values2(7)+1;
        case '9'
            values2(8)=values2(8)+1;
        case 'T'
            values2(9)=values2(9)+1;
        case 'J'
            values2(10)=values2(10)+1;
        case 'Q'
            values2(11)=values2(11)+1;
        case 'K'
            values2(12)=values2(12)+1;
        case 'A'
            values2(13)=values2(13)+1;
        otherwise
            disp('error value')
    end
end

% hand1
% hand2

% values1
% values2

best1_copies=max(values1);
best2_copies=max(values2);


% if streak of hand1 is longer, hand1 is better
if best1_copies > best2_copies
    resultIsBetter=1;
    return
end


% if streak of hand2 is longer, hand1 is better
if best1_copies < best2_copies
    resultIsBetter=0;
    return
end

% check Full Houses
if best1_copies == 3
    pairs1=sum(values1==2);
    pairs2=sum(values2==2);
    if pairs1 > pairs2
        resultIsBetter=1;
        return
    end
    if pairs1 < pairs2
        resultIsBetter=0;
        return
    end
end

% check double pair
if best1_copies == 2
    pairs1=sum(values1==2);
    pairs2=sum(values2==2);
    if pairs1 > pairs2
        resultIsBetter=1;
        return
    end
    if pairs1 < pairs2
        resultIsBetter=0;
        return
    end
end

% if I arrive here I have to pairwise match cards


for index=1:length(hand1_vec)
    card1=hand1_vec(index);
    card2=hand2_vec(index);
    card1_num=0;
    card2_num=0;

    switch card1
        case '2'
            card1_num=0;
        case '3'
            card1_num=1;
        case '4'
            card1_num=2;
        case '5'
            card1_num=3;
        case '6'
            card1_num=4;
        case '7'
            card1_num=5;
        case '8'
            card1_num=6;
        case '9'
            card1_num=7;
        case 'T'
            card1_num=8;
        case 'J'
            card1_num=9;
        case 'Q'
            card1_num=10;
        case 'K'
            card1_num=11;
        case 'A'
            card1_num=12;
        otherwise
            disp('error value')
    end

    switch card2
        case '2'
            card2_num=0;
        case '3'
            card2_num=1;
        case '4'
            card2_num=2;
        case '5'
            card2_num=3;
        case '6'
            card2_num=4;
        case '7'
            card2_num=5;
        case '8'
            card2_num=6;
        case '9'
            card2_num=7;
        case 'T'
            card2_num=8;
        case 'J'
            card2_num=9;
        case 'Q'
            card2_num=10;
        case 'K'
            card2_num=11;
        case 'A'
            card2_num=12;
        otherwise
            disp('error value')
    end

    if card1_num > card2_num
        resultIsBetter=1;
        return
    end

    if card1_num < card2_num
        resultIsBetter=0;
        return
    end
end

resultIsBetter=1;

end


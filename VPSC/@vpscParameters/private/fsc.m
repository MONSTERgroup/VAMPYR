function str = fsc(c1,c2,pos)
    c1 = sprintf(c1{1},c1{2:end});
    c2 = sprintf(c2{1},c2{2:end});
    offset = pos-length(c1);
    if offset <= 0
        offset = 2;
    end
    str = sprintf('%s%s%s', c1, repmat(' ', [offset 1]), c2);
end
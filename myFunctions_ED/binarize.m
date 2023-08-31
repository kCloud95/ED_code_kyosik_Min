function binaryEncoded = binarize(dataToBeEncoded, threshold)
    binaryEncoded = zeros(size(dataToBeEncoded));
    binaryEncoded(real(dataToBeEncoded)>threshold)=1;
    
end
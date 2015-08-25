FROM microsoft/aspnet:1.0.0-beta6
COPY ./App /App
RUN dnu restore /App
CMD ["dnx", "/App", "kestrel"]
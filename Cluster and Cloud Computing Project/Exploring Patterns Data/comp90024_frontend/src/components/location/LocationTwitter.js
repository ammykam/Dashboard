import { Provider, useDispatch } from "react-redux";
import { applyMiddleware, combineReducers, createStore } from "redux";

import KeplerGl from "kepler.gl";
import React from "react";
import { addDataToMap } from "kepler.gl/actions";
import keplerGlReducer from "kepler.gl/reducers";
import { processGeojson } from "kepler.gl/processors";
import { taskMiddleware } from "react-palm/tasks";
import useSwr from "swr";

const reducers = combineReducers({
  keplerGl: keplerGlReducer,
});

const store = createStore(reducers, {}, applyMiddleware(taskMiddleware));

export default function Location() {
  return (
    <Provider store={store}>
      <Map />
    </Provider>
  );
}

function Map() {
  const dispatch = useDispatch();
  const { data: locationData } = useSwr("covid", async () => {
    const response = await fetch(
      `${process.env.REACT_APP_BACKEND}/location-data`,
      {
        modes: "cors",
      }
    );
    const data = await response.json();
    return data;
  });

  const { data: crimeData } = useSwr("crime", async () => {
    const response = await fetch(`${process.env.REACT_APP_BACKEND}/crime`, {
      modes: "cors",
    });
    const data = await response.json();
    return processGeojson(data);
  });

  const { data: domesticViolenceData } = useSwr(
    "domestic-violence",
    async () => {
      const response = await fetch(
        `${process.env.REACT_APP_BACKEND}/domestic-violence`,
        {
          modes: "cors",
        }
      );
      const data = await response.json();
      return processGeojson(data);
    }
  );

  const { data: parkData } = useSwr("park", async () => {
    const response = await fetch(`${process.env.REACT_APP_BACKEND}/park`, {
      modes: "cors",
    });
    const data = await response.json();
    return processGeojson(data);
  });

  const { data: populationData } = useSwr("population", async () => {
    const response = await fetch(
      `${process.env.REACT_APP_BACKEND}/population`,
      {
        modes: "cors",
      }
    );
    const data = await response.json();
    return processGeojson(data);
  });

  const { data: salaryData } = useSwr("salary", async () => {
    const response = await fetch(`${process.env.REACT_APP_BACKEND}/salary`, {
      modes: "cors",
    });
    const data = await response.json();
    return processGeojson(data);
  });

  const { data: transportationData } = useSwr("transportation", async () => {
    const response = await fetch(
      `${process.env.REACT_APP_BACKEND}/transportation`,
      {
        modes: "cors",
      }
    );
    const data = await response.json();
    return processGeojson(data);
  });

  React.useEffect(() => {
    if (locationData) {
      dispatch(
        addDataToMap({
          datasets: [
            {
              info: {
                label: "Twitter Location Data",
                id: "twitter_location",
              },
              data: locationData,
            },
            {
              info: {
                label: "Crime Data",
                id: "crime_data",
              },
              data: crimeData,
            },
            {
              info: {
                label: "Domestic Violence Data",
                id: "domestic_violence_data",
              },
              data: domesticViolenceData,
            },
            {
              info: {
                label: "Park Data",
                id: "park_data",
              },
              data: parkData,
            },
            {
              info: {
                label: "Population Data",
                id: "population_data",
              },
              data: populationData,
            },
            {
              info: {
                label: "Salary Data",
                id: "salary_data",
              },
              data: salaryData,
            },
            {
              info: {
                label: "Salary Data",
                id: "salary_data",
              },
              data: {
                info: {
                  label: "Transportation Data",
                  id: "transportation_data",
                },
                data: transportationData,
              },
            },
          ],
          option: {
            centerMap: true,
            readOnly: false,
          },
          config: {
            version: "v1",
            config: {
              visState: {
                filters: [],
                layers: [
                  {
                    id: "9ljp2io",
                    type: "cluster",
                    config: {
                      dataId: "twitter_location",
                      label: "Point",
                      color: [41, 76, 181],
                      highlightColor: [252, 242, 26, 255],
                      columns: {
                        lat: "lat",
                        lng: "lon",
                      },
                      isVisible: true,
                      visConfig: {
                        opacity: 0.64,
                        clusterRadius: 60,
                        colorRange: {
                          name: "ColorBrewer YlGn-6",
                          type: "sequential",
                          category: "ColorBrewer",
                          colors: [
                            "#ffffcc",
                            "#d9f0a3",
                            "#addd8e",
                            "#78c679",
                            "#31a354",
                            "#006837",
                          ],
                        },
                        radiusRange: [0, 50],
                        colorAggregation: "average",
                      },
                      hidden: false,
                      textLabel: [
                        {
                          field: null,
                          color: [255, 255, 255],
                          size: 18,
                          offset: [0, 0],
                          anchor: "start",
                          alignment: "center",
                        },
                      ],
                    },
                    visualChannels: {
                      colorField: {
                        name: "poitive",
                        type: "integer",
                      },
                      colorScale: "quantile",
                    },
                  },
                  {
                    id: "di5kb98",
                    type: "geojson",
                    config: {
                      dataId: "crime_data",
                      label: "Crime Data",
                      color: [255, 203, 153],
                      highlightColor: [252, 242, 26, 255],
                      columns: {
                        geojson: "_geojson",
                      },
                      isVisible: true,
                      visConfig: {
                        opacity: 0.8,
                        strokeOpacity: 0.8,
                        thickness: 0.5,
                        strokeColor: [248, 149, 112],
                        colorRange: {
                          name: "ColorBrewer OrRd-6",
                          type: "sequential",
                          category: "ColorBrewer",
                          colors: [
                            "#fef0d9",
                            "#fdd49e",
                            "#fdbb84",
                            "#fc8d59",
                            "#e34a33",
                            "#b30000",
                          ],
                        },
                        strokeColorRange: {
                          name: "Global Warming",
                          type: "sequential",
                          category: "Uber",
                          colors: [
                            "#5A1846",
                            "#900C3F",
                            "#C70039",
                            "#E3611C",
                            "#F1920E",
                            "#FFC300",
                          ],
                        },
                        radius: 10,
                        sizeRange: [0, 10],
                        radiusRange: [0, 50],
                        heightRange: [0, 500],
                        elevationScale: 5,
                        enableElevationZoomFactor: true,
                        stroked: true,
                        filled: true,
                        enable3d: false,
                        wireframe: false,
                      },
                      hidden: false,
                      textLabel: [
                        {
                          field: null,
                          color: [255, 255, 255],
                          size: 18,
                          offset: [0, 0],
                          anchor: "start",
                          alignment: "center",
                        },
                      ],
                    },
                    visualChannels: {
                      colorField: {
                        name: "total_crime",
                        type: "integer",
                      },
                      colorScale: "quantile",
                      strokeColorField: null,
                      strokeColorScale: "quantile",
                      sizeField: null,
                      sizeScale: "linear",
                      heightField: null,
                      heightScale: "linear",
                      radiusField: null,
                      radiusScale: "linear",
                    },
                  },
                  {
                    id: "p6bby9r",
                    type: "geojson",
                    config: {
                      dataId: "domestic_violence_data",
                      label: "Domestic Violence Data",
                      color: [137, 218, 193],
                      highlightColor: [252, 242, 26, 255],
                      columns: {
                        geojson: "_geojson",
                      },
                      isVisible: false,
                      visConfig: {
                        opacity: 0.8,
                        strokeOpacity: 0.8,
                        thickness: 0.5,
                        strokeColor: null,
                        colorRange: {
                          name: "ColorBrewer Purples-6",
                          type: "singlehue",
                          category: "ColorBrewer",
                          colors: [
                            "#f2f0f7",
                            "#dadaeb",
                            "#bcbddc",
                            "#9e9ac8",
                            "#756bb1",
                            "#54278f",
                          ],
                        },
                        strokeColorRange: {
                          name: "Global Warming",
                          type: "sequential",
                          category: "Uber",
                          colors: [
                            "#5A1846",
                            "#900C3F",
                            "#C70039",
                            "#E3611C",
                            "#F1920E",
                            "#FFC300",
                          ],
                        },
                        radius: 10,
                        sizeRange: [0, 10],
                        radiusRange: [0, 50],
                        heightRange: [0, 500],
                        elevationScale: 5,
                        enableElevationZoomFactor: true,
                        stroked: true,
                        filled: true,
                        enable3d: false,
                        wireframe: false,
                      },
                      hidden: false,
                      textLabel: [
                        {
                          field: null,
                          color: [255, 255, 255],
                          size: 18,
                          offset: [0, 0],
                          anchor: "start",
                          alignment: "center",
                        },
                      ],
                    },
                    visualChannels: {
                      colorField: {
                        name: "total_crime",
                        type: "real",
                      },
                      colorScale: "quantile",
                      strokeColorField: null,
                      strokeColorScale: "quantile",
                      sizeField: null,
                      sizeScale: "linear",
                      heightField: null,
                      heightScale: "linear",
                      radiusField: null,
                      radiusScale: "linear",
                    },
                  },
                  {
                    id: "mgv2ljw",
                    type: "geojson",
                    config: {
                      dataId: "park_data",
                      label: "Park Data",
                      color: [66, 101, 204],
                      highlightColor: [252, 242, 26, 255],
                      columns: {
                        geojson: "_geojson",
                      },
                      isVisible: false,
                      visConfig: {
                        opacity: 0.8,
                        strokeOpacity: 0.8,
                        thickness: 0.5,
                        strokeColor: null,
                        colorRange: {
                          name: "ColorBrewer BrBG-6",
                          type: "diverging",
                          category: "ColorBrewer",
                          colors: [
                            "#8c510a",
                            "#d8b365",
                            "#f6e8c3",
                            "#c7eae5",
                            "#5ab4ac",
                            "#01665e",
                          ],
                        },
                        strokeColorRange: {
                          name: "Global Warming",
                          type: "sequential",
                          category: "Uber",
                          colors: [
                            "#5A1846",
                            "#900C3F",
                            "#C70039",
                            "#E3611C",
                            "#F1920E",
                            "#FFC300",
                          ],
                        },
                        radius: 10,
                        sizeRange: [0, 10],
                        radiusRange: [0, 50],
                        heightRange: [0, 500],
                        elevationScale: 5,
                        enableElevationZoomFactor: true,
                        stroked: true,
                        filled: true,
                        enable3d: false,
                        wireframe: false,
                      },
                      hidden: false,
                      textLabel: [
                        {
                          field: null,
                          color: [255, 255, 255],
                          size: 18,
                          offset: [0, 0],
                          anchor: "start",
                          alignment: "center",
                        },
                      ],
                    },
                    visualChannels: {
                      colorField: {
                        name: "total_park",
                        type: "integer",
                      },
                      colorScale: "quantile",
                      strokeColorField: null,
                      strokeColorScale: "quantile",
                      sizeField: null,
                      sizeScale: "linear",
                      heightField: null,
                      heightScale: "linear",
                      radiusField: null,
                      radiusScale: "linear",
                    },
                  },
                  {
                    id: "gykwqlu9",
                    type: "geojson",
                    config: {
                      dataId: "population_data",
                      label: "Population Data",
                      color: [221, 178, 124],
                      highlightColor: [252, 242, 26, 255],
                      columns: {
                        geojson: "_geojson",
                      },
                      isVisible: false,
                      visConfig: {
                        opacity: 0.8,
                        strokeOpacity: 0.8,
                        thickness: 0.5,
                        strokeColor: null,
                        colorRange: {
                          name: "ColorBrewer BrBG-6",
                          type: "diverging",
                          category: "ColorBrewer",
                          colors: [
                            "#8c510a",
                            "#d8b365",
                            "#f6e8c3",
                            "#c7eae5",
                            "#5ab4ac",
                            "#01665e",
                          ],
                        },
                        strokeColorRange: {
                          name: "Global Warming",
                          type: "sequential",
                          category: "Uber",
                          colors: [
                            "#5A1846",
                            "#900C3F",
                            "#C70039",
                            "#E3611C",
                            "#F1920E",
                            "#FFC300",
                          ],
                        },
                        radius: 10,
                        sizeRange: [0, 10],
                        radiusRange: [0, 50],
                        heightRange: [0, 500],
                        elevationScale: 5,
                        enableElevationZoomFactor: true,
                        stroked: true,
                        filled: true,
                        enable3d: false,
                        wireframe: false,
                      },
                      hidden: false,
                      textLabel: [
                        {
                          field: null,
                          color: [255, 255, 255],
                          size: 18,
                          offset: [0, 0],
                          anchor: "start",
                          alignment: "center",
                        },
                      ],
                    },
                    visualChannels: {
                      colorField: {
                        name: "all_person",
                        type: "integer",
                      },
                      colorScale: "quantile",
                      strokeColorField: null,
                      strokeColorScale: "quantile",
                      sizeField: null,
                      sizeScale: "linear",
                      heightField: null,
                      heightScale: "linear",
                      radiusField: null,
                      radiusScale: "linear",
                    },
                  },
                  {
                    id: "zm7zkts",
                    type: "geojson",
                    config: {
                      dataId: "salary_data",
                      label: "Salary Data",
                      color: [18, 92, 119],
                      highlightColor: [252, 242, 26, 255],
                      columns: {
                        geojson: "_geojson",
                      },
                      isVisible: false,
                      visConfig: {
                        opacity: 0.8,
                        strokeOpacity: 0.8,
                        thickness: 0.5,
                        strokeColor: null,
                        colorRange: {
                          name: "ColorBrewer Purples-6",
                          type: "singlehue",
                          category: "ColorBrewer",
                          colors: [
                            "#f2f0f7",
                            "#dadaeb",
                            "#bcbddc",
                            "#9e9ac8",
                            "#756bb1",
                            "#54278f",
                          ],
                        },
                        strokeColorRange: {
                          name: "Global Warming",
                          type: "sequential",
                          category: "Uber",
                          colors: [
                            "#5A1846",
                            "#900C3F",
                            "#C70039",
                            "#E3611C",
                            "#F1920E",
                            "#FFC300",
                          ],
                        },
                        radius: 10,
                        sizeRange: [0, 10],
                        radiusRange: [0, 50],
                        heightRange: [0, 500],
                        elevationScale: 5,
                        enableElevationZoomFactor: true,
                        stroked: true,
                        filled: true,
                        enable3d: false,
                        wireframe: false,
                      },
                      hidden: false,
                      textLabel: [
                        {
                          field: null,
                          color: [255, 255, 255],
                          size: 18,
                          offset: [0, 0],
                          anchor: "start",
                          alignment: "center",
                        },
                      ],
                    },
                    visualChannels: {
                      colorField: {
                        name: "income",
                        type: "integer",
                      },
                      colorScale: "quantile",
                      strokeColorField: null,
                      strokeColorScale: "quantile",
                      sizeField: null,
                      sizeScale: "linear",
                      heightField: null,
                      heightScale: "linear",
                      radiusField: null,
                      radiusScale: "linear",
                    },
                  },
                ],
                interactionConfig: {
                  tooltip: {
                    fieldsToShow: {
                      twitter_location: [
                        {
                          name: "places",
                          format: null,
                        },
                        {
                          name: "negative",
                          format: null,
                        },
                        {
                          name: "neutral",
                          format: null,
                        },
                        {
                          name: "poitive",
                          format: null,
                        },
                        {
                          name: "total",
                          format: null,
                        },
                      ],
                      crime_data: [
                        {
                          name: "code",
                          format: null,
                        },
                        {
                          name: "name",
                          format: null,
                        },
                        {
                          name: "total_crime",
                          format: null,
                        },
                        {
                          name: "year",
                          format: null,
                        },
                      ],
                      domestic_violence_data: [
                        {
                          name: "code",
                          format: null,
                        },
                        {
                          name: "name",
                          format: null,
                        },
                        {
                          name: "total_crime",
                          format: null,
                        },
                        {
                          name: "violence_percentage",
                          format: null,
                        },
                        {
                          name: "year",
                          format: null,
                        },
                      ],
                      park_data: [
                        {
                          name: "code",
                          format: null,
                        },
                        {
                          name: "name",
                          format: null,
                        },
                        {
                          name: "total_park",
                          format: null,
                        },
                      ],
                      population_data: [
                        {
                          name: "all_female",
                          format: null,
                        },
                        {
                          name: "all_male",
                          format: null,
                        },
                        {
                          name: "all_person",
                          format: null,
                        },
                        {
                          name: "code",
                          format: null,
                        },
                        {
                          name: "fem_adult",
                          format: null,
                        },
                      ],
                      salary_data: [
                        {
                          name: "code",
                          format: null,
                        },
                        {
                          name: "income",
                          format: null,
                        },
                        {
                          name: "name",
                          format: null,
                        },
                      ],
                    },
                    compareMode: false,
                    compareType: "absolute",
                    enabled: true,
                  },
                  brush: {
                    size: 0.5,
                    enabled: false,
                  },
                  geocoder: {
                    enabled: false,
                  },
                  coordinate: {
                    enabled: false,
                  },
                },
                layerBlending: "normal",
                splitMaps: [],
                animationConfig: {
                  currentTime: null,
                  speed: 1,
                },
              },
              mapState: {
                bearing: 0,
                dragRotate: false,
                latitude: -36.56068401254651,
                longitude: 145.04661420847629,
                pitch: 0,
                zoom: 6,
                isSplit: false,
              },
              mapStyle: {
                styleType: "dark",
                topLayerGroups: {},
                visibleLayerGroups: {
                  label: true,
                  road: true,
                  border: false,
                  building: true,
                  water: true,
                  land: true,
                  "3d building": false,
                },
                threeDBuildingColor: [
                  9.665468314072013, 17.18305478057247, 31.1442867897876,
                ],
                mapStyles: {},
              },
            },
          },
        })
      );
    }
  }, [
    dispatch,
    locationData,
    crimeData,
    domesticViolenceData,
    parkData,
    populationData,
    salaryData,
    transportationData,
  ]);
  //function, what changes
  return (
    <KeplerGl
      id="data"
      mapboxApiAccessToken={process.env.REACT_APP_MAPBOX_API}
      width={window.innerWidth * 0.82}
      height={window.innerHeight}
      showAddDataPanel={false}
    />
  );
}

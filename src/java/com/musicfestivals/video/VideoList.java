package com.musicfestivals.video;

import com.musicfestivals.app.GlobalVars;
import com.musicfestivals.app.JSFParamGetter;
import com.musicfestivals.festival.Festival;
import com.musicfestivals.query.DataQuery;
import java.io.Serializable;
import java.util.List;
import javax.annotation.PostConstruct;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;

@ManagedBean(name = "videoList")
@ViewScoped
public class VideoList implements Serializable {

    private List<Video> videoList;
    private Festival festival;
    private final DataQuery query = new DataQuery();
    
    

    @PostConstruct
    public void init() {
        FacesContext fc = FacesContext.getCurrentInstance();
        JSFParamGetter paramGetter = new JSFParamGetter(fc);
        long dataId = paramGetter.getLongParametar("dataId");
        if (dataId > 0) {
            setFestival(query.getEntityManager().createNamedQuery("Festival.findById", Festival.class).setParameter("id", dataId).getSingleResult());
        } else {
            setFestival(new Festival());
        }

    }

    public List<Video> getVideoList() {
        videoList = query.getEntityManager().createNamedQuery("Video.findByFestivalId", Video.class).setParameter("festivalId", getFestival().getId()).getResultList();
        return videoList;
    }

    public Festival getFestival() {       
        return festival;
    }

    public void setFestival(Festival festival) {
        this.festival = festival;
    }
    
    public String getPath(){
        return GlobalVars.getPathToImages();
    }
}

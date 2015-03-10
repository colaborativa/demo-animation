  width               = 1050
  height              = 625

  # Create patch of triangles that spans the view
  shapeobj = seen.Shapes.tetrahedron()
  shapeback = seen.Shapes.tetrahedron()  

  shape = seen.Shapes.tetrahedron()
  .scale(0.1)
  .translate(0,0,-700)
  .rotx(0)

  model = seen.Models.default().add(shape)

  scene = new seen.Scene
    model    : model
    viewport : seen.Viewports.center(width, height)
    camera   : new seen.Camera
        projection : seen.Projections.perspective()
  
  # Load the object file using jquery
  $.get 'assets/logo.obj', {}, (contents) ->
  # Create shape from object file
    shapeobj = seen.Shapes.obj(contents, false)
    shapeobj.scale(1).translate(0,0,0).rotx(0).roty(0).rotz(0)
  # Update scene model
    seen.Colors.randomSurfaces2(shapeobj)
    model.add(shapeobj)


  $.get 'assets/background.obj', {}, (contents) ->
  # Create shape from object file
    shapeback = seen.Shapes.obj(contents, false)
    shapeback.scale(1).translate(0,0,-1).rotx(0).roty(0).rotz(0)
    seen.Colors.randomShape(shapeback,0.05,1.22)
  # Update scene model
    
    model.add(shapeback)

  context = seen.Context('seen-canvas', scene).render()

# Apply animated 3D simplex noise to patch vertices
  t = 0
  noiserback = new Simplex3D(shapeback)
  noiserobj= new Simplex3D(shapeobj)
  context.animate()
    .onBefore((t,dt)->
      for surf in shapeback.surfaces
        surf.originals = surf.points.map (p) -> p.copy()
        surf.fill.color.a = 100 # Add a little transparency
        for p in surf.points
          p.z = 4*noiserback.noise(p.x, p.y, t*1e-4)
        # Since we're modifying the point directly, we need to mark the surface dirty
        # to make sure the cache doesn't ignore the change
        surf.dirty = true
      for surf in shapeobj.surfaces
        surf.originals = surf.points.map (p) -> p.copy()
        surf.fill.color.a = 250 # Add a little transparency
        for p in surf.points
          p.z = 13*noiserback.noise(p.x/20, p.y/20, t*1e-4)
        # Since we're modifying the point directly, we need to mark the surface dirty
        # to make sure the cache doesn't ignore the change
        surf.dirty = true  
    )
    .start()